import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;





/**
 *
 * @author mahmoud mammar
 * @author michele grisafi
 */
public class Battery {

	public static void main(String[] args) {
		
		if(args.length < 2){
			System.out.println("Please, specify the destination file and the execution time:\njava Battery.java <destinationFilePath> <executionTime(ms)>");
		}else{
			//Get path of destination file
			String path = args[0];

			//Get execution time from second argument
			double execTime = Double.parseDouble(args[1]);
			System.out.println(String.format("Computing rate for '%s' executing in %f ms", path.substring(path.lastIndexOf('/')+1,path.lastIndexOf('.')),execTime));
			
			//Computer power consumption
			computePowerConsumption(path,execTime);
		}

	}

	public static void computePowerConsumption(String path, double executionTime){
		
		/* Technical details about consumption, to be taken from datasheet */
		/* The following data are for MSP430F5529 */

		// Please provide the value of ampere per Hour for the battery used!
		double battery_ampere_Hour = 3; 

		// Please indicate the power consumption in the sleep mode (from the datasheet)
		double sleep_mode_Amp = 290 * Math.pow(10, -6); 

		// Please indicate the power consumption in the active mode (from the datasheet)		
		double active_mode_Amp = 1.9 * Math.pow(10, -3); 

		// Please indicate the execution time of your protocol													
		double excution_time_sec = executionTime/1000; 

		// Leave it; this is used later.
		double execution_rate_sec = 0; 

		// If you evaluate your protocol with several options that make the
		// execution time variant, please indicate all of them here! If
		// you have only the aformentioned one, only write it again.
		double arr_extec_time[] = { executionTime/1000 }; 
														
		// The output will be two columns: the first one: Rate, which indicates how
		// often your protocol runs, whereas the second one is Years, which indicates
		// the number of years that the bettery will last at this rate.
		StringBuilder obj_builder = new StringBuilder();
		obj_builder.append("Rate,Years\n"); 

		// The various intervals in minutes
		double[] interval = new double[]{1,2,4,8,12,15,30,45,60,120,180,240,300,600,900,1800,2700,3600,7200,14400,21600,32400,43200,86400};
		
		//Cycle over the various intervals defined above
		for (int r = 0; r < interval.length; r += 1) { 
												
			obj_builder.append(interval[r]);
			
			//Pick r-th interval
			execution_rate_sec = interval[r];

			//For each execution time
			for (double esce : arr_extec_time) {
				excution_time_sec = esce;

				//Compute days 
				double days = get_battery_life_time_in_days(battery_ampere_Hour, sleep_mode_Amp, active_mode_Amp,
						excution_time_sec, execution_rate_sec);
				
				//Compute and write years
				obj_builder.append("," + days / 365);
			}

			obj_builder.append("\n");

		}

		// Please change the path of the output file. Use your own path. 
		// The data will be written in a .csv file. You can visualize it afterward. 
		write_file(path, obj_builder.toString()); 

	}

	//Write to a file
	public static void write_file(String path, String text) {
		Writer writer = null;

		try {
			writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), "utf-8"));
			writer.write(text);
		} catch (IOException ex) {
			// report
		} finally {
			try {
				writer.close();
			} catch (Exception ex) {/* ignore */
			}
		}
	}

	//Compute the battery life
	public static double get_battery_life_time_in_days(double battery_ampere_Hour, double sleep_mode_Amp,
			double active_mode_Amp, double excution_time_sec, double execution_rate_sec) {

		double sleep_period = execution_rate_sec - excution_time_sec;
		double active_perod = excution_time_sec;

		if (execution_rate_sec == 0) {
			return (battery_ampere_Hour / (sleep_mode_Amp)) / 24;
		}

		if (execution_rate_sec < excution_time_sec) {
			System.out.println("Error check rate and excution time");
			System.exit(0);
		}

		double comunsmed_ampere_Hour = 0;
		double amp_consumed_per_period = sleep_period * sleep_mode_Amp + active_mode_Amp * active_perod;
		int step = 0;
		while (battery_ampere_Hour > comunsmed_ampere_Hour) {

			comunsmed_ampere_Hour = step * amp_consumed_per_period / (3600);

			step++;
		}

		return (step * execution_rate_sec) / (3600 * 24);
	}

}
