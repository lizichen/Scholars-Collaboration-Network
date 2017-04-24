import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class AllResultsReducer extends Reducer<Text, IntWritable, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<IntWritable> values, Context context) 
			throws IOException, InterruptedException {
		
		int totalReps = 0;
		
		for(IntWritable value: values){
			totalReps = totalReps + (int)value.get();
		}

		String count = ",\"" + totalReps + "\"";
		context.write(key, new Text(count));
	}
}
