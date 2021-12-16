package ca.jrvs.apps.grep;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class JavaGrepLambda extends JavaGrepImp {
    public static void main(String[] args) {
        if (args.length != 3) {
            JavaGrepLambda javaGrepLambdaImp = new JavaGrepLambda();
            javaGrepLambdaImp.setRegex(args[0]);
            javaGrepLambdaImp.setRootPath(args[1]);
            javaGrepLambdaImp.setOutFile(args[2]);

            try {
                javaGrepLambdaImp.process();

            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    public List<File> listFiles(String rootDir) {
        List<File> result = new ArrayList<>();
        try{
            result= Files.walk(Paths.get(rootDir)).filter(Files::isRegularFile).map(Path::toFile).collect(Collectors.toList());

        }catch(Exception ex){
            logger.error("File not Found Exception", ex);
        }
        return result;
    }

    @Override
    public List<String> readLines(File inputFile){
        List<String> Line_List = new ArrayList<>();
        try {
            Line_List = Files.lines(Paths.get(inputFile.getPath())).collect(Collectors.toList());

        }catch(Exception ex){
            logger.error("Input Output Exception", ex);
        }

        return Line_List;
    }
}