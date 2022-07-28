# This shell script emits a C file. -*- C -*-
#   Copyright (C) 2006-2020 Free Software Foundation, Inc.
#
# This file is part of the GNU Binutils.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston,
# MA 02110-1301, USA.
#

# This file is sourced from generic.em
#
fragment <<EOF
#include "elf-bfd.h"
#include "ldelfgen.h"

EOF
source_em ${srcdir}/emultempl/elf-generic.em
fragment <<EOF

static void
gld${EMULATION_NAME}_after_open (void)
{
  bfd *ibfd;
  asection *sec;
  asymbol **syms;

  after_open_default ();

  if (bfd_link_relocatable (&link_info))
    for (ibfd = link_info.input_bfds; ibfd != NULL; ibfd = ibfd->link.next)
      if ((syms = bfd_get_outsymbols (ibfd)) != NULL
	  && bfd_get_flavour (ibfd) == bfd_target_elf_flavour)
	for (sec = ibfd->sections; sec != NULL; sec = sec->next)
	  if ((sec->flags & (SEC_GROUP | SEC_LINKER_CREATED)) == SEC_GROUP)
	    {
	      struct bfd_elf_section_data *sec_data = elf_section_data (sec);
	      struct bfd_symbol *sym = syms[sec_data->this_hdr.sh_info - 1];
	      elf_group_id (sec) = sym;
	      sym->flags |= BSF_KEEP;
	    }

  if (bfd_get_flavour (link_info.output_bfd) != bfd_target_elf_flavour
      || bfd_link_relocatable (&link_info))
    return;

  FOR_MSYM_IN_MSYM_HASH_TABLE (link_info.output_bfd, i, entry, msym)
    {
      /* Orphan SMK_LOCATION sections by renaming them so they don't match a
         linker script rule.  We can then move the new output sections around,
         or remove those output sections to put the input section in a
         different, existing output section.  */
      if (msym->msym.kind == SMK_LOCATION)
	/* FIXME include the address in the name.  */
	bfd_rename_section (msym->sym->section, concat (".smi.location.", msym->sym->name, (const char *)NULL));
    }
}

static void
gld${EMULATION_NAME}_before_allocation (void)
{
  if (bfd_link_relocatable (&link_info)
      && !_bfd_elf_size_group_sections (&link_info))
    einfo (_("%X%P: can not size group sections: %E\n"));
  before_allocation_default ();
}

/* Return the SMK_LOCATION metasym with the lowest value in S.
   Return NULL if there is no SMK_LOCATION metasym in S.  */
static struct bfd_elf_metasym_hash_entry *
check_sec_for_locsym (asection *s)
{
  struct bfd_elf_metasym_hash_entry *ret = NULL;
  FOR_MSYM_IN_MSYM_HASH_TABLE (link_info.output_bfd, i, entry, msym)
    {
      if (msym->msym.kind == SMK_LOCATION && msym->sym->section == s
	  && (ret == NULL || msym->msym.value < ret->msym.value))
	ret = msym;
    }
  return ret;
}

/* Return a pointer to the input section statement for input section IS within
   the list L.  If there is a padding statement immediately preceding the input
   section, return that.  */
static lang_statement_union_type **
find_input_section_statement (lang_statement_union_type ** l, asection *is)
{
  lang_statement_union_type ** prev_pad = NULL;
  lang_statement_union_type ** ret;
  for (; (*l) != NULL; l = &(*l)->header.next)
    {
      switch ((*l)->header.type)
	{
	case lang_input_section_enum:
	  if ((*l)->input_section.section == is)
	    {
	      return (prev_pad != NULL ? prev_pad : l);
	    }
	  break;

	case lang_padding_statement_enum:
	  prev_pad = l;
	  break;

	case lang_wild_statement_enum:
	  ret = find_input_section_statement (&(*l)->wild_statement.children.head, is);
	  if (ret != NULL)
	    return ret;
	  break;

	default:
	  break;
	}

      /* Unless we set prev_pad on the previous iteration, reset it.  */
      if ((*l)->header.type != lang_padding_statement_enum)
	prev_pad = NULL;
    }
  return NULL;
}

static bfd_vma
locsym_addr_adj_required (struct bfd_elf_metasym_hash_entry *msym)
{
  asection *is = msym->sym->section;
  asection *os = msym->sym->section->output_section;

  lang_relax_sections (FALSE);
  return msym->msym.value - os->vma - is->output_offset;
}

/* Insert an assignment statement before IS, to move it forward by AMT bytes.
   We silently return if AMT is negative, as we assume a postive AMT will be
   set for this section on a subsequent call.  */
static void
insert_ass (asection *is, bfd_size_type amt)
{
  lang_statement_union_type *ass = NULL;
  asection *os = is->output_section;
  lang_output_section_statement_type * os_stat;
  lang_statement_union_type **ptr;

  if ((long)amt < 0)
    return;

  /* Find the location at which to insert the assignment statement.  */
  os_stat = lang_output_section_find (os->name);
  ptr = find_input_section_statement (&os_stat->children.head, is);

  if (!ptr)
    return;

  /* Make a new assignment statement, linked into existing chain.  */
  ass = stat_alloc (sizeof (lang_assignment_statement_type));
  ass->header.next = *ptr;
  *ptr = ass;
  ass->header.type = lang_assignment_statement_enum;
  /* Set the dot to the desired address, relative to the beginning of the
     output section of IS.  */
  ass->assignment_statement.exp
    = exp_assign (".", exp_intop (is->output_offset + amt), FALSE);

  lang_relax_sections (FALSE);
}

/* Insert input section before PTR.  */
static void
insert_input_section (asection *is, lang_statement_union_type **ptr)
{
  lang_statement_union_type *sec = NULL;
  sec = stat_alloc (sizeof (lang_input_section_type));
  sec->input_section.section = is;
  sec->header.type = lang_input_section_enum;
  sec->header.next = *ptr;
  *ptr = sec;
}

/* Initialize an output section with a wild statement.  */
static void
insert_wild (lang_statement_list_type *list)
{
  lang_wild_statement_type *wild = NULL;

  wild = stat_alloc (sizeof (lang_wild_statement_type));
  wild->header.next = NULL;
  wild->header.type = lang_wild_statement_enum;

  wild->filename = NULL;
  wild->filenames_sorted = FALSE;
  wild->section_flag_list = NULL;
  wild->exclude_name_list = NULL;
  wild->section_list = NULL;
  wild->keep_sections = FALSE;
  lang_list_init (&wild->children);

  *(list->tail) = (void *)wild;
  list->tail = &wild->header.next;

  lang_relax_sections (FALSE);
}

/* Initialize a new lang_statement_union_type with the given output section
   statement.  */
static lang_statement_union_type *
insert_os_stat (lang_output_section_statement_type *os_stat)
{
  lang_statement_union_type *new_stmt;
  new_stmt = stat_alloc (sizeof (lang_output_section_statement_type));
  new_stmt->header.type = lang_output_section_statement_enum;

  new_stmt->output_section_statement = *os_stat;
  new_stmt->output_section_statement.addr_tree = NULL;
  new_stmt->header.next = NULL;
  return new_stmt;
}



/* Below are a collection of functions used for sorting sections by their
   expected output VMA.  These have been adapted from their original definitions
   in ld/lang.c.  */

/* Compare sections ASEC and BSEC according to SORT.  */
static int
compare_section (asection *sec1, asection *sec2)
{
  /* We add the section size to the VMA of non-locsym sections so that if a
     locsym VMA is in the middle of a section, that section will be placed after
     the locsym section and the locsym can be added to the correct location.  */
  bfd_vma vma1 = sec1->output_section->vma + sec1->output_offset + sec1->size;
  bfd_vma vma2 = sec2->output_section->vma + sec2->output_offset + sec2->size;
  struct bfd_elf_metasym_hash_entry *msym1 = check_sec_for_locsym (sec1);
  struct bfd_elf_metasym_hash_entry *msym2 = check_sec_for_locsym (sec2);
  if (msym1)
    vma1 = msym1->msym.value;
  if (msym2)
    vma2 = msym2->msym.value;

  if (vma1 < vma2)
    return -1;
  /* If a locsym and non-locsym have the same expected output VMA, we
     prioritize the locsym and place that first.  */
  if (vma1 == vma2 && msym1 && !msym2)
    return -1;
  return 0;
}

/* Build a Binary Search Tree to sort sections, unlike insertion sort
   used in wild_sort().  BST is considerably faster if the number of
   of sections are large.  */
static lang_section_bst_type **
wild_sort_fast (lang_section_bst_type **tree,
		asection *section)
{
  while (*tree)
    {
      /* Find the correct node to append this section.  */
      if (compare_section (section, (*tree)->section) < 0)
	tree = &((*tree)->left);
      else
	tree = &((*tree)->right);
    }
  return tree;
}

/* Use wild_sort_fast to build a BST to sort sections.  */
static void
output_section_callback_fast (lang_section_bst_type **tree,
			      asection *section)
{
  lang_section_bst_type *node;

  node = (lang_section_bst_type *) xmalloc (sizeof (lang_section_bst_type));
  node->left = 0;
  node->right = 0;
  node->section = section;

  tree = wild_sort_fast (tree, section);
  if (tree != NULL)
    *tree = node;
}


/* Convert a sorted sections' BST back to list form.  */
static void
output_section_callback_tree_to_list (lang_statement_list_type *ptr,
				      lang_section_bst_type *tree,
				      void *output)
{
  if (tree->left)
    output_section_callback_tree_to_list (ptr, tree->left, output);

  tree->section->output_section = NULL;

  lang_add_section (ptr, tree->section, NULL,
		    (lang_output_section_statement_type *) output);

  struct bfd_elf_metasym_hash_entry *msym = check_sec_for_locsym (tree->section);
  bfd_vma adj;
  if (msym != NULL
      && ((adj = locsym_addr_adj_required (msym)) != 0))
    insert_ass (tree->section, adj);

  if (tree->right)
    output_section_callback_tree_to_list (ptr, tree->right, output);

  free (tree);
}

/* End BST sorting.  */


/* Shuffle the input sections within ROOT so they are ordered in ascending
   output VMA order, taking into account the desired VMA of SMK_LOCATION
   metasyms.  */
static void
shuffle_secs (lang_statement_list_type *root)
{
  lang_section_bst_type *node;
  lang_statement_union_type *l;
  lang_output_section_statement_type *os;
  if (root->head == NULL)
    return;

  /* We might have a padding or assignment statement at the beginning of the
     wild, so find the first input section.  */
  for (l = root->head; l != NULL; l = l->header.next)
    if (l->header.type == lang_input_section_enum)
      break;

  if (l == NULL)
    return;

  node = (lang_section_bst_type *) xmalloc (sizeof (lang_section_bst_type));
  node->left = 0;
  node->right = 0;
  node->section = l->input_section.section;

  for (l = l->header.next; l != NULL; l = l->header.next)
    if (l->header.type == lang_input_section_enum)
      output_section_callback_fast (&node, l->input_section.section);

  lang_list_init (root);
  os = lang_output_section_find (node->section->output_section->name);
  output_section_callback_tree_to_list (root, node, os);

  lang_relax_sections (FALSE);
}

/* Return TRUE if the address specified for the SMK_LOCATION metasym MSYM is
   within the range of addresses spanned by the input sections in L.  */
static bfd_boolean
calc_wild_range (lang_statement_list_type *l,
		 struct bfd_elf_metasym_hash_entry *msym)
{
  bfd_vma start = 0;
  bfd_vma end = 0;
  lang_statement_union_type *i;
  asection *is = NULL;
  lang_relax_sections (FALSE);
  for (i = l->head; i != NULL; i = i->header.next)
    {
      if (i->header.type != lang_input_section_enum)
	continue;
      is = i->input_section.section;

      /* L should be sorted by output VMA, but we do some extra checks
	 anyway...  */
      if (start == 0 || is->output_offset + is->output_section->vma < start)
	start = is->output_offset + is->output_section->vma;

      if (is->output_offset + is->output_section->vma + is->size > end)
	end = is->output_offset + is->output_section->vma + is->size;
    }

  if (msym->msym.value >= start && msym->msym.value <= end)
    return TRUE;
  return FALSE;
}

/* Descend into the statement list which begins at ROOT, and detach S from the
   wild statement it is in if PLACE is FALSE.
   If DUMP is TRUE, print some debugging statements.
   Return TRUE once we've found and detached the input section.  */
static bfd_boolean
detach_input_sec (asection *s, lang_statement_list_type *root,
		  bfd_boolean dump)
{
  asection *is;
  lang_statement_union_type * prev = NULL;
  lang_statement_union_type * curr;

  if (root == stat_ptr && dump)
    printf ("\ndetach_input_sec\n");

  for (curr = root->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_input_section_enum:
	  is = curr->input_section.section;
	  if (dump)
	    printf ("    input section %s\n", is->name);
	  if (is == s)
	    {
	      if (dump)
		printf ("    detaching this sec %s\n", is->name);

	      if (s->output_section
		  && strncmp (s->output_section->name, ".smi.location.", strlen (".smi.location.")) != 0)
		s->output_section = bfd_get_section_by_name (link_info.output_bfd, s->name);

	      /* If this is the last statement, and we are detaching this
		 statement, we have to point the list tail to the previous
		 elements' next pointer.  */
	      if (curr->header.next == NULL)
		root->tail = &prev->header.next;

	      /* Adjust the next statement pointed to by the previous element.  */
	      if (prev == NULL)
		root->head = curr->header.next;
	      else
		prev->header.next = curr->header.next;

	      /* This statement is no longer part of any list, so clear the next
		 element it points to.  */
	      curr->header.next = NULL;

	      /* In case we remove subsequent entries, always maintain prev to
		 be the last one that was actually kept in the list (prev gets set to
		 curr at the end of this function).  */
	      curr = prev;

	      lang_relax_sections (FALSE);
	      return TRUE;
	    }
	  break;

	case lang_output_section_statement_enum:
	  if (!curr->output_section_statement.bfd_section)
	    break;
	  if (dump && curr->output_section_statement.bfd_section)
	    printf ("    output section %s VMA 0x%lx size 0x%lx\n", curr->output_section_statement.name, curr->output_section_statement.bfd_section->vma,  curr->output_section_statement.bfd_section->size);

	  /* Descend into this output section.  */
	  if (detach_input_sec (s, &curr->output_section_statement.children, dump))
	    return TRUE;
	  break;

	case lang_wild_statement_enum:
	  if (dump)
	    printf ("    wild statement\n");
	  if (detach_input_sec (s, &curr->wild_statement.children, dump))
	    return TRUE;
	  break;

	case lang_group_statement_enum:
	  if (dump)
	    printf ("    group statement section\n");
	  if (detach_input_sec (s, &curr->group_statement.children, dump))
	    return TRUE;
	  break;

	default:
	  break;
	}
      prev = curr;
    }
  return FALSE;
}

/* Detach the output section S from the list that starts from root.  */
static bfd_boolean
detach_output_sec (asection *s, lang_statement_list_type *root,
		  bfd_boolean dump)
{
  asection *os;
  lang_statement_union_type * prev = NULL;
  lang_statement_union_type * curr;
  lang_output_section_statement_type * os_stat;

  if (dump)
    printf ("\ndetach_output_sec\n");

  for (curr = root->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_output_section_statement_enum:
	  os_stat = &curr->output_section_statement;
	  if (!os_stat->bfd_section)
	    break;

	  if (dump && os_stat->bfd_section)
	    printf ("    output section %s VMA 0x%lx size 0x%lx\n",
		    os_stat->name,
		    os_stat->bfd_section->vma,
		    os_stat->bfd_section->size);

	  os = os_stat->bfd_section;

	  if (os == s)
	    {
	      if (dump)
		printf ("    detaching here\n");

	      /* If this is the last statement, and we are detaching this
		 statement, we have to point the list tail to the previous
		 elements' next pointer.  */
	      if (curr->header.next == NULL)
		root->tail = &prev->header.next;

	      /* Adjust the next statement pointed to by the previous element.  */
	      if (prev == NULL)
		root->head = curr->header.next;
	      else
		prev->header.next = curr->header.next;

	      /* This statement is no longer part of any list, so clear the next
		 element it points to.  */
	      curr->header.next = NULL;

	      /* In case we remove subsequent entries, always maintain prev to
	         be the last one that was actually kept in the list (prev gets set to
		 curr at the end of this function).  */
	      curr = prev;

	      lang_relax_sections (FALSE);
	      return TRUE;
	    }
	  break;

	case lang_group_statement_enum:
	  if (dump)
	    printf ("    group statement section\n");
	  if (detach_output_sec (s, &curr->group_statement.children, dump))
	    return TRUE;
	  break;

	default:
	  if (dump)
	    printf ("    statement type %d\n", curr->header.type);
	  break;
	}
      prev = curr;
    }
  return FALSE;
}

/* Convenience function to detach a locsym entirely from ROOT (orphan it).
   If the output section of the locsym is a "real" section that was specified
   in the linker script, i.e. not an output section created just for the locsym,
   we do not detach that output section from ROOT.  */
static void
detach_locsym (struct bfd_elf_metasym_hash_entry *msym, lang_statement_list_type *root,
		  bfd_boolean dump)
{
  asection *os = msym->sym->section->output_section;
  detach_input_sec (msym->sym->section, root, dump);
  if (os
      && strncmp (os->name, ".smi.location.", strlen (".smi.location.")) == 0)
    detach_output_sec (msym->sym->section->output_section, stat_ptr, dump);
}

/* A list of generic wild rules which we can put a locsym in without it
   disturbing some special ordering specified by the linker script.
   We are trying to avoid placing locsyms inside a wild statement for
   sections such as .crt*, .{init,fini}_array}, .{ctors,dtors} etc.
   We also use this to deduce the type of a memory region.
   XXX Changes to this list must be reflect in the wild_whitelist_elem enum.
   FIXME, should make this an array of struct wiht one elem being the string
   and the other being the associated type.  */
static const char * wild_whitelist[34] = {
    ".text",		".text.*",
    ".upper.text",	".upper.text.*",
    ".lower.text",	".lower.text.*",
    ".either.text",	".either.text.*",

    ".rodata",		".rodata.*",
    ".upper.rodata",	".upper.rodata.*",
    ".lower.rodata",	".lower.rodata.*",
    ".either.rodata",	".either.rodata.*",

    ".data",		".data.*",
    ".upper.data",	".upper.data.*",
    ".lower.data",	".lower.data.*",
    ".either.data",	".either.data.*",

    ".bss",		".bss.*",
    ".upper.bss",	".upper.bss.*",
    ".lower.bss",	".lower.bss.*",
    ".either.bss",	".either.bss.*",

    "COMMON",

    /* Terminate the list.  */
    NULL
};

enum wild_whitelist_elem {
    WW_READONLY = 0,
    WW_TEXT = 0,
    WW_RODATA = 8,
    WW_READ_WRITE = 16,
    WW_DATA = 16,
    WW_BSS = 24,
};

#define LOCSYM_FLAG_MASK (SEC_DATA | SEC_LOAD | SEC_READONLY | SEC_CODE)

#define LOCSYM_SEC_DATA (SEC_DATA | SEC_LOAD)
#define LOCSYM_SEC_RODATA (SEC_DATA | SEC_LOAD | SEC_READONLY)
#define LOCSYM_SEC_BSS (0)
#define LOCSYM_SEC_TEXT (SEC_CODE | SEC_READONLY | SEC_LOAD)

/* Rules for placement within wilds:
   DATA -> (DATA | RODATA | TEXT)
     We can place .data in .rodata or .text because we know the memory region
     is writeable.  The initial value of the data will be loaded as if it was
     .rodata.
   RODATA -> (DATA | RODATA | TEXT)
     We can't place .rodata in .bss because the initial load value will be
     overwritten when the .bss output section is zero'd.
     We should be able to place .rodata in .data, since the memory region is
     loadable, so they are treated the same except .rodata shouldn't be overwritten
     by the program.
   BSS -> (DATA | RODATA | BSS | TEXT)
     We can place .bss anywhere because the memory region is writeable, and the
     VMA of the variable will be stored in __smi_location_init_array, and so
     will be initialized to 0 just before main.
   TEXT -> (DATA | RODATA | TEXT)
     When LMA of .data != VMA, then as long as the .text section has its contents
     in the LMA area, then it can be copied to DATA. Like a RAMFUNC.

   TODO if we could save the initial values of text/data/rodata somewhere
   (like an LMA region for these variables), we could also place them in a
   RAM-like memory region and initialize them with
   __crt0_run_smi_location_init_array.  */

/* This contains all the required logic to decide if we can place a section
   with MSYM_FLAGS inside a wild statement or memory region with TARGET_FLAGS.
   The decision making changes depending on if we are checking if the region is
   compatible (CHECK_REGION_COMPAT == TRUE), or a wild is compatible.
   One of the key points for below is that we can't place anything with an
   initial value in the .bss section, unless that value is going to be copied
   over from a different LMA using smi_location_run_init_array, because bss
   initialization will wipe the loaded values at the VMA.  */
static bfd_boolean
verify_flag_compatibility (flagword msym_flags, flagword target_flags,
			   bfd_boolean check_region_compat)
{
  msym_flags &= LOCSYM_FLAG_MASK;
  target_flags &= LOCSYM_FLAG_MASK;

  if (msym_flags == target_flags)
    return TRUE;

  if (msym_flags == LOCSYM_SEC_BSS)
    {
      /* We can place .bss anywhere writeable.  */
      if (check_region_compat && ((target_flags & SEC_READONLY) == 0))
	return TRUE;

      if (!check_region_compat)
	/* Place .bss locsyms anywhere if the region is already compatible.  */
	return TRUE;

      return FALSE;
    }

  /* We can place .text/.rodata/.data anywhere except .bss if the region is
     compatible.  */
  if (!check_region_compat
      && (target_flags == LOCSYM_SEC_DATA
	  || target_flags == LOCSYM_SEC_TEXT
	  || target_flags == LOCSYM_SEC_RODATA))
    return TRUE;

  if (msym_flags == LOCSYM_SEC_DATA)
    {
      /* We can place .data anywhere writeable.  */
      if (check_region_compat && ((target_flags & SEC_READONLY) == 0))
	return TRUE;
      return FALSE;
    }

  if (msym_flags == LOCSYM_SEC_TEXT)
    {
      /* We can place .text anywhere executable.  */
      if (check_region_compat && (target_flags & SEC_CODE))
	return TRUE;
      return FALSE;
    }

  if (msym_flags == LOCSYM_SEC_RODATA)
    {
      /* We can place .rodata anywhere readonly.  */
      if (check_region_compat && (target_flags & SEC_READONLY))
	return TRUE;
      return FALSE;
    }
  return FALSE;
}

static flagword
get_flags_for_wild (int allowed_wild)
{
  if (allowed_wild >= WW_BSS)
    return LOCSYM_SEC_BSS;
  else if (allowed_wild >= WW_DATA)
    return LOCSYM_SEC_DATA;
  else if (allowed_wild >= WW_RODATA)
    return LOCSYM_SEC_RODATA;
  else
    return LOCSYM_SEC_TEXT;
}

/* Find the wild statement within os_stat that would contain the target address
   of MSYM, and return TRUE if that wild statement is compatible with the type
   of MSYM.
   Before this function is called, we've already confirmed that MSYM is
   compatible with the memory region of OS_STAT (e.g. for a .data MSYM, the
   region is writeable).  */
static bfd_boolean
verify_wild_compatibility (struct bfd_elf_metasym_hash_entry *msym,
			   lang_output_section_statement_type * os_stat)
{
  lang_statement_list_type * list = &os_stat->children;
  lang_statement_union_type *curr;
  struct wildcard_list *wild_list = NULL;
  const int dump = 0;
  flagword msym_flags = msym->sym->section->flags & LOCSYM_FLAG_MASK;
  lang_wild_statement_type *target_wild = NULL;

  if (dump)
    printf ("trying to place locsym %s with flags 0x%x\n",
	    msym->sym->name, msym_flags);

  /* Find the wild statement containing the target address.  */
  for (curr = list->head; curr != NULL; curr = curr->header.next)
    {
      if (curr->header.type == lang_wild_statement_enum
	  && calc_wild_range (&curr->wild_statement.children, msym))
	{
	  target_wild = &curr->wild_statement;
	  break;
	}
      else if (curr->header.type == lang_input_section_enum)
	{
	  /* The msp430 .either placement just attaches .either input
	     sections to the corresponding output section.
	     This should be the only case of input sections directly attached
	     to the output section's child list that we need to handle.  */
	  asection *s = curr->input_section.section;
	  if (!s)
	    continue;

	  if (strncmp (s->name, ".either.", strlen (".either.")) == 0)
	    {
	      const char *allowed_wild_str = NULL;
	      int allowed_wild;

	      for (allowed_wild = 0, allowed_wild_str = wild_whitelist[allowed_wild];
		   allowed_wild_str != NULL;
		   allowed_wild_str = wild_whitelist[++allowed_wild])
		{
		  if (strncmp (allowed_wild_str, s->name, strlen(allowed_wild_str)) == 0)
		    break;
		}
	      flagword wild_flags = get_flags_for_wild (allowed_wild);

	      if (verify_flag_compatibility (msym_flags, wild_flags, FALSE))
		return TRUE;
	    }
	}
    }

  /* We couldn't find a wild statement containing the target address.  */
  if (target_wild == NULL)
    return FALSE;

  /* Iterate over each of the individual wild rules in the wild
     statement.  */
  for (wild_list = target_wild->section_list;
       wild_list != NULL; wild_list = wild_list->next)
    {
      const char *allowed_wild_str = NULL;
      int allowed_wild;

      /* Check this is a wild statement we know to have no special
	 properties or enforced ordering of its elements, so we can
	 place any locsym within it.  */
      for (allowed_wild = 0, allowed_wild_str = wild_whitelist[allowed_wild];
	   allowed_wild_str != NULL;
	   allowed_wild_str = wild_whitelist[++allowed_wild])
	{
	  if (strcmp (allowed_wild_str, wild_list->spec.name) == 0)
	    break;
	}

      /* The wild statement was not on the whitelist.  */
      if (allowed_wild_str == NULL)
	continue;

      flagword wild_flags = get_flags_for_wild (allowed_wild);

      if (verify_flag_compatibility (msym_flags, wild_flags, FALSE))
	return TRUE;
    }
  /* We've examined all the wild rules within the wild statement that
     contains our target address, and none of the rules were acceptable for
     the locsym, so we can't place the locsym within this output
     section.  */
  return FALSE;
}

static bfd_boolean
verify_region_compatibility (lang_memory_region_type *region,
			    lang_statement_list_type *root,
			    flagword section_flags)
{
  /* Go over all the output/input sections within a region and build up a
   * flagword variable which has all the types of sections within that region.
   * That helps us work out if the region is ROM/RAM/FRAM.  */

  /* If the program doesn't have sections of a certain type within a region, we
   * may not accurately deduce what is allowed within that region.  In that
   * case we need to also check the wild statements allowed in that region
   * again known names to help us work out the flags.  */

  const int dump = 0;
  section_flags &= LOCSYM_FLAG_MASK;

  /* Start with the flags set on the region, if any.  We use the not flags at
     the end.  */
  if (verify_flag_compatibility (section_flags, region->flags, TRUE))
    return TRUE;

  lang_statement_union_type * curr = NULL;
  for (curr = root->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_output_section_statement_enum:
	  if (curr->output_section_statement.region == region)
	    {
	      asection *os = curr->output_section_statement.bfd_section;
	      const char *secname;
	      int allowed_wild;
	      if (os == NULL)
		continue;
	      if (dump)
		printf ("  %s is in the same region with flags 0x%x\n", os->name, os->flags & LOCSYM_FLAG_MASK);

	      if (verify_flag_compatibility (section_flags, os->flags, TRUE))
		return TRUE;

	      /* If the output section does not have any contents then the
		 flags will be incomplete.  So infer the flags from its
		 name.  */
	      for (allowed_wild = 0, secname = wild_whitelist[allowed_wild];
		   secname != NULL;
		   secname = wild_whitelist[++allowed_wild])
		{
		  if (strcmp (secname, os->name) != 0)
		    continue;

		  flagword wild_flags = get_flags_for_wild (allowed_wild);
		  if (verify_flag_compatibility (section_flags, wild_flags, TRUE))
		    return TRUE;
		  break;
		}

	      /* We still haven't decided this output section is compatible, so
	         look at its children.  */
	      if (verify_region_compatibility (region, &curr->output_section_statement.children, section_flags))
		return TRUE;
	    }
	  break;
	case lang_wild_statement_enum:
	  if (root == stat_ptr)
	    /* We should only have found a wild_statement when descending into
	       the list attached to an output_section_statement.  */
	    break;

	  if (dump)
	    printf ("    wild statement %s\n", curr->wild_statement.section_list->spec.name);

	  struct wildcard_list *wild_list;
	  for (wild_list = curr->wild_statement.section_list;
	       wild_list != NULL; wild_list = wild_list->next)
	    {
	      const char *allowed_wild_str;
	      int allowed_wild;
	      /* Check this is a wild statement we know to have no special
		 properties or enforced ordering of its elements, so we can
		 place any locsym within it.  */
	      for (allowed_wild = 0, allowed_wild_str = wild_whitelist[allowed_wild];
		   allowed_wild_str != NULL;
		   allowed_wild_str = wild_whitelist[++allowed_wild])
		{
		  if (strcmp (allowed_wild_str, wild_list->spec.name) == 0)
		    break;
		}
	      if (allowed_wild_str != NULL)
		{
		  flagword wild_flags = get_flags_for_wild (allowed_wild);
		  if (verify_flag_compatibility (section_flags, wild_flags, TRUE))
		    return TRUE;
		  break;
		}
	    }
	  break;
	default:
	  break;
	}
    }
  /* FIXME handling ! region flags */
  /*region_flags &= !(region->not_flags);*/

  return FALSE;
}

/* Check a memory region exists at the given address, and that we can
   place the locsym in that region.  */
static lang_memory_region_type *
validate_locsym_addr (struct bfd_elf_metasym_hash_entry *msym, bfd_boolean validate_flags)
{
  bfd_vma addr = msym->msym.value;
  lang_memory_region_type *r;
  for (r = get_memory_region_list (); r != NULL; r = r->next)
    {
      if (addr >= r->origin && addr < r->origin + r->length
	  /* The default memory region spans the entire address space.  */
	  && strcmp ("*default*", r->name_list.name) != 0)
	{
	  /* Check the region we want to place the locsym in is compatible with its
	     section type.  */
	  if (validate_flags
	      && (!verify_region_compatibility (r, stat_ptr, msym->sym->section->flags)))
	    {
	      einfo (_("%P: warning: SMK_LOCATION metasym '%s' is not compatible "
		       "with the memory region '%s' containing address 0x%v\n"),
		      msym->sym->name, r->name_list.name, msym->msym.value);
	      return NULL;
	    }
	  return r;
	}
    }
  if (validate_flags)
    einfo (_("%P: warning: no valid memory region at address 0x%v for "
	     "SMK_LOCATION metasym '%s'\n"), msym->msym.value,
	   msym->sym->name);
  return NULL;
}

/* Create a list of SMK_LOCATION metasyms, sorted in ascending order of their
   desired VMA.
   Return the number of locsyms in the list.
   TODO we could use a faster algorithm for creating this sorted list.  */
static unsigned int
create_sorted_locsym_list (struct bfd_elf_metasym_hash_entry **list)
{
  unsigned int placed = 0;
  unsigned int j;
  const int dump = 0;
  FOR_MSYM_IN_MSYM_HASH_TABLE (link_info.output_bfd, i, entry, msym)
    {
      if (msym->msym.kind != SMK_LOCATION)
	continue;

      if (link_info.gc_sections && !msym->sym->section->gc_mark)
	{
	  if (dump)
	    printf ("%s has been garbage collected\n", msym->sym->section->name);
	  continue;
	}

      if (dump)
	printf ("create_sorted_locsym_list for %s\n", msym->sym->name);


      if (check_sec_for_locsym (msym->sym->section) != msym)
	{
	  einfo (_("%P: warning: only one SMK_LOCATION metasym allowed per section. "
		   "ignoring metasym '%s' in section %s\n"),
		   msym->sym->name, msym->sym->section->name);
	  continue;
	}

      /* Before we go any further, validate the address of locsym.
	 We may not be able to place it at all.  */
      if (validate_locsym_addr (msym, TRUE) == NULL)
	continue;

      /* Detach the locsyms from the global statement list.  This ensures that
         regular sections are in accurate positions each time we go to look at
         placing the locsyms.  */
      detach_locsym (msym, stat_ptr, FALSE);

      if (placed == 0)
	{
	  list[0] = msym;
	  placed++;
	  continue;
	}
      for (j = 0; j < placed; j++)
	{
	  if (msym->msym.value < list[j]->msym.value)
	    {
	      unsigned int k;
	      for (k = placed; k > j; k--)
		list[k] = list[k - 1];
	      list[j] = msym;
	      break;
	    }
	}
      if (j == placed)
	list[j] = msym;
      placed++;
    }
  return placed;
}

/* For the given locsym MSYM, find the output section which would contain
   its desired output value.
   We don't do any validation that the return output section is actually
   compatible with MSYM.  */
static lang_output_section_statement_type *
find_containing_os (struct bfd_elf_metasym_hash_entry *msym)
{
  lang_statement_union_type * curr = stat_ptr->head;
  lang_output_section_statement_type * os_stat;
  bfd_vma addr = msym->msym.value;
  const int dump = 0;
  if (dump)
    printf ("\nfind_containing_os for %s at addr 0x%lx\n", msym->sym->name, addr);

  for (curr = stat_ptr->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{

	case lang_output_section_statement_enum:
	  os_stat = &curr->output_section_statement;
	  /* Only consider output sections which will actually be part of the
	     executing program.  */
	  if (os_stat->bfd_section && (os_stat->bfd_section->flags & SEC_ALLOC))
	    {
	      if (dump)
		printf ("  %s vma 0x%lx size 0x%lx\n", os_stat->bfd_section->name,
			os_stat->bfd_section->vma, os_stat->bfd_section->size);

	      /* Check if the locsym would have to be placed within an existing
		 output section.  */
	      if (addr >= os_stat->bfd_section->vma
		  && addr < (os_stat->bfd_section->vma
			     + os_stat->bfd_section->size))
		return os_stat;
	    }
	  break;

	default:
	  break;
	}
    }
  return NULL;
}

/* Return TRUE if OS_STAT is the last output section in it's memory region.
   This accounts for non-consecutive output sections assigned to the same
   memory region, only the last output section counts.  */
static bfd_boolean
last_os_in_region (lang_statement_union_type *os_stat)
{
  lang_statement_union_type *curr;
  lang_memory_region_type *region = os_stat->output_section_statement.region;
  for (curr = os_stat->header.next; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_output_section_statement_enum:
	  if (curr->output_section_statement.region == region)
	    return FALSE;
	default:
	  /* FIXME: Do we need to handle group statements?  */
	  break;
	}
    }
  return TRUE;
}

/* Place msym before the output section os_stat. If os_stat is NULL, there
   should be free space at the desired address of MSYM and we attach it to the
   statement list as required.  */
static lang_output_section_statement_type *
move_locsym_os (struct bfd_elf_metasym_hash_entry *msym, lang_statement_list_type *root,
		lang_output_section_statement_type * before_os_stat)
{
  lang_statement_union_type * curr = root->head;
  lang_statement_union_type * prev = NULL;
  bfd_vma addr = msym->msym.value;
  lang_output_section_statement_type * os_stat;
  asection *os;
  const int dump = 0;

  /* We detached the output section statements for all locsyms earlier, now
     find it, and reattach it.  */
  os_stat = lang_output_section_find (msym->sym->section->output_section->name);

  /* We don't seem to be able to get a list of output sections attached to a
   * given region, so just iterate over the output sections till we find it.
   If we don't see the region, we can just create a new output section statement
   and attach it to the region.  */
  /* BUT we need to make sure to operate within regions here, since the
   * sections are only ordered according to VMA within regions, and we will
   * sometimes need to place it at the end of the region.  */

  for (curr = root->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_output_section_statement_enum:
	  if (curr->output_section_statement.bfd_section
	      && validate_locsym_addr (msym, FALSE) == curr->output_section_statement.region)
	    {
	      os = curr->output_section_statement.bfd_section;
	      if (dump)
		printf ("  %s vma 0x%lx size 0x%lx\n", os->name,
			os->vma, os->size);

	      /* Update the memory region if necessary.  */
	      os_stat->region = curr->output_section_statement.region;

	      /* If we've gone past the desired VMA of our locsym, we need to
	         insert its section before this one.  */
	      if (os->vma >= addr
		  || (before_os_stat && os == before_os_stat->bfd_section))
		{
		  lang_statement_union_type *new_stmt = insert_os_stat (os_stat);
		  new_stmt->output_section_statement.addr_tree = exp_intop (addr);

		  if (dump)
		    printf ("  INSERT %s HERE, before %s\n", msym->sym->name, os->name);

		  if (prev == NULL)
		    root->head = new_stmt;
		  else
		    prev->header.next = new_stmt;

		  new_stmt->header.next = curr;
		  return &new_stmt->output_section_statement;

		}
	      /* If we've reached the end of the statement list, or the next
	         output section is in a different memory region, attach the
	         locsym after the current output section.  */
	      else if (curr->header.next == NULL
		       || last_os_in_region (curr))
		{
		  lang_statement_union_type *new_stmt = insert_os_stat (os_stat);
		  new_stmt->output_section_statement.addr_tree = exp_intop (addr);

		  if (dump)
		    printf ("    INSERT %s HERE, after %s\n", msym->sym->name, os->name);

		  if (curr->header.next == NULL)
		    {
		      new_stmt->header.next = NULL;
		      root->tail = &new_stmt->header.next;
		    }
		  else
		    new_stmt->header.next = curr->header.next;

		  curr->header.next = new_stmt;

		  return &new_stmt->output_section_statement;
		}
	    }
	  break;
	default:
	  if (dump)
	    printf ("  statement type %d\n", curr->header.type);
	  break;
	}
      prev = curr;
    }
  return NULL;
}

static bfd_boolean
insert_locsym_init_arr_start (void )
{
  lang_statement_union_type * curr = NULL;
  lang_relax_sections (FALSE);

  for (curr = stat_ptr->head; curr != NULL; curr = curr->header.next)
    {
      switch (curr->header.type)
	{
	case lang_output_section_statement_enum:
	  if (curr->output_section_statement.bfd_section
	      && strcmp (curr->output_section_statement.bfd_section->name,
			 ".smi.location_init_array") == 0)
	    {
	      /* FIXME this gets orphaned at the end of the map file would be
		 good to attach it for aesthetics.  */
	      lang_add_assignment (exp_provide ("__smi_location_init_array_start",
						exp_intop (curr->output_section_statement.bfd_section->vma),
						FALSE));
	      return TRUE;
	    }
	  break;
	default:
	  break;
	}
    }
  return FALSE;
}

/* Place SMK_LOCATION* meta-information entries (abbreviated as "locsyms") at
   their requested addresses, if possible.  */
static void
place_locsyms (void)
{
  if (elf_metasym_count (link_info.output_bfd) == 0)
    return;

  struct bfd_elf_metasym_hash_entry **list
    = xmalloc (sizeof (struct bfd_elf_metasym_hash_entry *)
	       * elf_metasym_count (link_info.output_bfd));
  unsigned int num_loc = create_sorted_locsym_list (list);
  bfd_boolean need_locsym_init_array = (num_loc != 0);
  unsigned int i, j;
  lang_output_section_statement_type * os_stat;
  struct bfd_elf_metasym_hash_entry * msym;
  const int dump = 0;

  unsigned int loopnum = 0;
  unsigned int max_loopnum = (num_loc * num_loc) + 100;
  max_loopnum = (max_loopnum < num_loc ? (unsigned int)-1 : max_loopnum);
  bfd_boolean changed_locsym_list = FALSE;

  /* FIXME need to detect if we are in an endless loop.
     e.g. when two locsyms
     keep changing order in the list with no progress being made,
     and report to the user that "the selected placement is not possible".  */
   do
    {
      if (loopnum++ > max_loopnum)
	break;

      if (dump)
	printf ("\n******************\nstarting loop over %d msyms again\n", num_loc);

      for (i = 0; i < num_loc; i++)
	{
	  msym = list[i];
	  os_stat = find_containing_os (msym);

	  /* If there is no existing output section at the desired VMA of the
	     locsym, we can place it directly.
	     If the locsym does overlap with an output section, and the wild
	     statement we would try to place it in is not compatible with the
	     locsym type, we have to place the locsym's output section before
	     that output section.
	     Note that we cannot place locsyms directly inside an output
	     section, (e.g. in a new wild statement) as that might disturb
	     assignments or other special ordering enforced by the linker
	     script.
	     We only place within allowed wild statements inside the output
	     section, or in an entirely new output section.  */
	  if (os_stat == NULL
	      || !verify_wild_compatibility (msym, os_stat))
	    {
	      if (dump)
		printf ("\nplace %s freely (move_locsym_os) - target addr 0x%lx\n", msym->sym->name, msym->msym.value);

	      if ((os_stat = move_locsym_os (msym, stat_ptr, os_stat)) == NULL)
		{
		  einfo (_("%P: error: unable to place SMK_LOCATION "
			   "metasym %s\n"), msym->sym->name);
		  continue;
		}

	      /* Refresh this .smi.location output section, which should only
	         ever contain a .smi.location input section.  */
	      lang_list_init (&os_stat->children);
	      insert_wild (&os_stat->children);
	      /* We need to clear the output section before calling
		 lang_add_section.  */
	      msym->sym->section->output_section = NULL;
	      lang_add_section (&os_stat->children.head->wild_statement.children,
				msym->sym->section, NULL, os_stat);
	    }
	  else
	    {
	      if (dump)
		printf ("\nplace %s within %s - target addr 0x%lx\n", msym->sym->name, os_stat->bfd_section->name, msym->msym.value);

	      lang_statement_union_type *curr;
	      lang_statement_union_type *prev = NULL;
	      for (curr = os_stat->children.head; curr != NULL; prev = curr, curr = curr->header.next)
		{
		  /* Input sections are always within wild statements within output
		     sections, even if the input section in rule in the linker script
		     does not contain any wildcards.
		     The exception is msp430 .either sections, these are
		     attached directly to the output section and are handled below.  */
		  if (curr->header.type == lang_wild_statement_enum
		      && calc_wild_range (&curr->wild_statement.children, msym))
		    {
		      /* If the specified VMA of the locsym is within the range of this
			 wild, we must shuffle the input sections within the wild
			 statement to get it placed at the right address.  */
		      msym->sym->section->output_section = NULL;
		      lang_add_section (&curr->wild_statement.children,
					msym->sym->section, NULL,
					os_stat);
		      shuffle_secs (&curr->wild_statement.children);
		      break;
		    }
		  else if (curr->header.type == lang_input_section_enum)
		    {
		      bfd_vma either_addr;

		      asection *s = curr->input_section.section;
		      if (!s)
			continue;
		      if (strncmp (s->name, ".either.", strlen (".either.")) != 0)
			continue;

		      either_addr = os_stat->bfd_section->vma + s->output_offset + s->size;

		      /* Find the first either section after our desired
		         VMA.  */
		      if (either_addr < msym->msym.value)
			continue;

		      if (dump)
			printf ("  place %s before %s\n", msym->sym->section->name, s->name);

		      msym->sym->section->output_section = os_stat->bfd_section;

		      if (prev == NULL)
			insert_input_section (msym->sym->section, &os_stat->children.head);
		      else
			insert_input_section (msym->sym->section, &prev->header.next);

		      insert_ass (msym->sym->section, locsym_addr_adj_required (msym));
		      break;
		    }
		}
	      if (curr == NULL)
		einfo (_("%P: internal error placing SMK_LOCATION metasym %s\n"),
			 msym->sym->name);
	    }
	  lang_relax_sections (FALSE);

	  /* Check if the locsym we just played has ruined the placement of any
	     of the locsyms we placed earlier.  */
	  unsigned int new_idx = 0;
	  unsigned int num_placed = i;
	  unsigned int new_num_loc = num_loc;
	  changed_locsym_list = FALSE;
	  for (j = 0; j < num_loc; j++)
	    {
	      struct bfd_elf_metasym_hash_entry *inv_msym = list[j];
	      bfd_vma adj;
	      /* Only consider the locsyms already placed.  */
	      if (j < num_placed
		  && (adj = locsym_addr_adj_required (inv_msym)) != 0)
		{
		  struct bfd_elf_metasym_hash_entry **new_list;

		  if (dump)
		    printf ("ADJUSTMENT REQUIRED for %s (curr 0x%lx target 0x%lx) after placing %s\n",
			    inv_msym->sym->name, inv_msym->msym.value - adj, inv_msym->msym.value, msym->sym->name);

		  /* If we're stuck placing the first locsym, and we haven't
		     placed any locsyms yet, there's no shuflling we'll be able
		     to do to get it to fit, so don't try to place it.  */
		  if (j == 0 && num_placed == 0)
		    {
		      einfo (_("%P: warning: unable to accurately place SMK_LOCATION metasym %s\n"),
			     msym->sym->name);
		      /* Setting j to 1 means this locsym will be removed from
		         the worklist.  */
		      j = 1;
		    }

		  /* We've "locked in" the first J msyms, so remove these from
		     the work list.  */
		  new_num_loc -= j;
		  new_list = xmalloc (sizeof (struct bfd_elf_metasym_hash_entry *)
				      * new_num_loc);

		  /* Move the locsym we just placed, which invalidated the later
		     locsyms, to the front of the list.  */
		  if (dump)
		    printf ("moving %s from pos %d to pos %d\n", msym->sym->name, i, new_idx);
		  new_list[new_idx++] = msym;

		  detach_locsym (msym, stat_ptr, FALSE);
		  for (; j < num_loc; j++)
		    {
		      inv_msym = list[j];
		      /* Don't place the locsym we moved to the front of the
			 list again.  */
		      if (inv_msym == new_list[0])
			continue;

		      if (dump)
			printf ("new moving %s from pos %d to pos %d\n", inv_msym->sym->name, j, new_idx);
		      new_list[new_idx++] = inv_msym;
		      detach_locsym (inv_msym, stat_ptr, FALSE);
		    }

		  /* Copy to the old list then free the new list.  */
		  num_loc = new_num_loc;
		  for (j = 0; j < num_loc; j++)
		    list[j] = new_list[j];
		  free (new_list);

		  changed_locsym_list = TRUE;
		  break;
		}
	      else if (j >= num_placed)
		{
		  /* All locsyms placed so far have had their addresses
		     successfully validated.  */
		  break;
		}
	    }
	  if (changed_locsym_list)
	    /* Start again with the new list.  */
	    break;
	}
    } while (changed_locsym_list);

   /* We may not have any locsyms anymore if they were garbage collected, but
      the init_array table and crt0_run_smi_location_init_array have already
      been created and the output executable finalized so we must define the
      symbol to prevent "undefined reference to...".
      However, if we don't NEED the symbol to be defined, don't error if the
      init_array section can't be found.  */
   if (!insert_locsym_init_arr_start () && need_locsym_init_array )
     einfo (_("%P: couldn't find .smi.location_init_array section to define "
	      "__smi_location_init_array_start"));
}

/* Once we've placed all the locsyms, remove any left over BFD output sections
 * from locsyms which have now been placed within other "real" sections.  */
static void
fixup_os_list (void)
{
  asection *s;
  for (s = link_info.output_bfd->sections; s != NULL; s = s->next)
    {
      if (strncmp (s->name, ".smi.location.", strlen (".smi.location.")) != 0)
	continue;

      if (s->size == 0)
	{
	  bfd_section_list_remove (link_info.output_bfd, s);
	  link_info.output_bfd->section_count--;
	}
    }
}

static void
gld${EMULATION_NAME}_after_allocation (void)
{
  /* Check the output format is ELF and that we aren't doing a relocatable link.  */
  if (bfd_get_flavour (link_info.output_bfd) != bfd_target_elf_flavour
      || bfd_link_relocatable (&link_info))
    return;

  if (elf_tdata (link_info.output_bfd))
    {
      place_locsyms ();
      fixup_os_list ();
    }
  ldelf_map_segments (FALSE);
}
EOF
# Put these extra routines in ld_${EMULATION_NAME}_emulation
#
LDEMUL_AFTER_OPEN=gld${EMULATION_NAME}_after_open
LDEMUL_BEFORE_ALLOCATION=gld${EMULATION_NAME}_before_allocation
LDEMUL_AFTER_ALLOCATION=gld${EMULATION_NAME}_after_allocation
