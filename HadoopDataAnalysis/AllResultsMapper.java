
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;



public class AllResultsMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

	private final static IntWritable ONE = new IntWritable(1);
	private final static IntWritable ZERO = new IntWritable(0);
	private final static String[] KEYWORDS = {"hackathon",  "Java", "Dec", "Chicago"};
	
	@Override
	public void map(LongWritable key, Text value, Context context) 
			throws IOException, InterruptedException {

		String line = value.toString().toLowerCase();
		context.write(new Text(line), ONE);
	}
}