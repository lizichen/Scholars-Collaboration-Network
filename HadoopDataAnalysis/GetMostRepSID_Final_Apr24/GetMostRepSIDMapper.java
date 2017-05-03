import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.io.ArrayWritable;
import org.apache.hadoop.io.Writable;


public class GetMostRepSIDMapper  extends Mapper<LongWritable, Text, Text, ArrayWritable> {

        @Override
        public void map(LongWritable key, Text value, Context context)
                        throws IOException, InterruptedException {

                String line = value.toString().toLowerCase();


		//"aaron"   ,"   barth"  ,"   36088948300"  ,"   7193"	,"    14"
//"aaron","barth","32516"	,""36088948300"","14"
		
		String[] items = line.split(",\"");
		if(items.length==5){
		
			String fn = items[0]; // "aaron"
			String ln = items[1]; // barth"
			String sid = "\"" + items[2]; // 36088948300"
			String aid = items[3].trim(); // 7193"
			String reps = items[4];  // 14"

			String key1 = fn + ",\"" + ln + ",\"" + aid;

			String[] writables = new String[2];
			writables[0] = sid; // "36088948300"
			writables[1] = reps; 
	                context.write(new Text(key1), new TextArrayWritable(writables));
		}

        }
}

