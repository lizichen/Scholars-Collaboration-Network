import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.io.ArrayWritable;
import org.apache.hadoop.io.Writable;
import java.lang.Integer;

public class GetMostRepSIDReducer extends Reducer<Text, TextArrayWritable, Text, Text> {

        @Override
        public void reduce(Text key, Iterable<TextArrayWritable> values, Context context)
                        throws IOException, InterruptedException {

                int maxReps = 0;
		String sid = "";
/*
		for(TextArrayWritable value: values){
			Writable[] writables = value.get();
			Text repstext = (Text)writables[1];
			String reps_st_o = repstext.toString(); // 2"
                        String reps_st = reps_st_o.split("\"")[0];
                        int reps = Integer.parseInt(reps_st);
			if(reps > maxReps){
                                maxReps = reps;
                        }
		}
*/
                for(TextArrayWritable value: values){
			Writable[] writables = value.get();	
			Text sidtext = (Text)writables[0];
			Text repstext = (Text)writables[1];

			String c_sid = sidtext.toString();

			String reps_st_o = repstext.toString(); // 2"
			String reps_st = reps_st_o.split("\"")[0];
			int reps = Integer.parseInt(reps_st);
			
			if(reps > maxReps){
				sid = c_sid;
				maxReps = reps;
				//String sid_count = "," + c_sid + ",\"" + maxReps +"\"";
				//context.write(key, new Text(sid_count));
			}
                }

                String sid_count = "," + sid + ",\"" + maxReps +"\"";
                context.write(key, new Text(sid_count));

		for(TextArrayWritable value: values){
			Writable[] writables = value.get();
                        Text sidtext = (Text)writables[0];
                        Text repstext = (Text)writables[1];

                        String c_sid = sidtext.toString();

                        String reps_st_o = repstext.toString(); // 2"
                        String reps_st = reps_st_o.split("\"")[0];
                        int reps = Integer.parseInt(reps_st);

                        if(reps == maxReps){
                                sid_count = "," + c_sid + ",\"" + maxReps +"\"";
				context.write(key, new Text(sid_count));
			}
		}	
        }
}
