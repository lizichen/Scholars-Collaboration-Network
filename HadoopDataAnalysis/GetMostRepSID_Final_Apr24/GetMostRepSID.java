
import java.io.IOException;

import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.io.ArrayWritable;

public class GetMostRepSID {

	public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException{
		if(args.length != 2){
			System.out.println("Usage: <input_path> <output_path>");
			System.exit(-1);
		}
		
		Job job = new Job();
		job.setJarByClass(GetMostRepSID.class);
		job.setJobName("GetMostRepSID");
		
		FileInputFormat.addInputPath(job, new Path(args[0]));
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		
		job.setMapperClass(GetMostRepSIDMapper.class);
		job.setReducerClass(GetMostRepSIDReducer.class);
		
		job.setOutputKeyClass(Text.class);
//		job.setOutputValueClass(ArrayWritable.class);
	//	job.setOutputValueClass(Text.class);		
		job.setOutputValueClass(TextArrayWritable.class);

		System.exit(job.waitForCompletion(true) ? 0 :1);
		
	}
}
