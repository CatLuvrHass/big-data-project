import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;


import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.conf.Configuration;

public class Connecting {

    public static class TokenizerMapper extends Mapper<Object, Text, Text, Text> {

        private Text routeNo = new Text();
        private Text port = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
            
                StringTokenizer itr = new StringTokenizer(value.toString());

                routeNo.set(split[3].trim());
                
                port.set(split[0].trim());
                    
                context.write(routeNo, port);

            }
        }
    }

    public static class PortsPerRouteReducer extends Reducer<Text, Text, Text, Text> {
        private Text result = new Text();

        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            // empty set
            Set<String> ports = new HashSet<>();
		
            for (Text port : values) {
                ports.add(port.toString());
            }
            
            String portString = String.join("|| ", ports);
            
            //filter output for only one we want
            if (portString.contains("Midnightblue-Epsilon")) {
       	// write to context
                result.set(portString);
                context.write(key, result);
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "portsOfRoute");
        job.setJarByClass(Connecting.class);
        job.setMapperClass(TokenizerMapper.class);
        job.setCombinerClass(PortsPerRouteReducer.class);
        job.setReducerClass(PortsPerRouteReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
