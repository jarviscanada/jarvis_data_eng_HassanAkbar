package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.apache.log4j.BasicConfigurator;

import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.*;


public class JavaGrepImp implements JavaGrep{

    final Logger logger = LoggerFactory.getLogger(JavaGrep.class);

    private String regex;
    private String rootPath;
    private String outFile;

    @Override
    public String getRegex() {
        return regex;
    }

    @Override
    public void setRegex(String regex) {
        this.regex = regex;
    }

    @Override
    public void process() throws IOException{
        List<String> matchedLines = new ArrayList<>();
        List<File>  Files = listFiles(getRootPath());
        for(File file: Files){
            List<String> lines = readLines(file);
            for(String line: lines){
                if(containsPattern(line)){
                    matchedLines.add(line);
                }
            }
        }
        writeToFile(matchedLines);
    }

    @Override
    public List<File> listFiles(String rootDir) throws FileNotFoundException {
        File dirPath = new File(rootDir);
        File[] fileList = dirPath.listFiles();
        if (fileList == null) {
            try {
                throw new FileNotFoundException("Error: root path is empty");
            } catch (FileNotFoundException e) {
                logger.error("FileNotFoundException", e);
            }

        }
        List<File> result = new ArrayList<>();
        for (File file : fileList)
            if (file.isFile()) {
                result.add(file);
            } else {
                String subDirName = file.getAbsolutePath();
                result.addAll(listFiles(subDirName));
            }
        return result;
    }

    @Override
    public List<String> readLines(File inputFile) throws IOException {
        List<String> lineList = new ArrayList<>();

        try {
            BufferedReader br = new BufferedReader(new FileReader(inputFile));
            String line;
            line = br.readLine();
            while ((line = br.readLine()) !=null) {
                lineList.add(line);
            }
            br.close();
        }
        catch (IOException e){
            logger.error("IO Exception", e);
        }

        return lineList;
    }

    @Override
    public boolean containsPattern(String line) {
        return line.matches(getRegex());
    }

    @Override
    public void writeToFile(List<String> lines) throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(getOutFile()));
        for (String eachLine : lines) {
            writer.write(eachLine + System.lineSeparator());
        }
        writer.close();
    }


    @Override
    public String getRootPath() {
        return rootPath;
    }

    @Override
    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    @Override
    public String getOutFile() {
        return outFile;
    }

    @Override
    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }


    public static void main(String[] args) {
        if(args.length != 3){
            throw new IllegalArgumentException("Usage: JavaGrep regex rootPth outFile");
        }

        BasicConfigurator.configure();

        JavaGrepImp javaGrepImp = new JavaGrepImp();
        javaGrepImp.setRegex(args[0]);
        javaGrepImp.setRootPath(args[1]);
        javaGrepImp.setOutFile(args[2]);

        try{
            javaGrepImp.process();
        }
        catch (Exception ex){
            javaGrepImp.logger.error("Error: unable to process",ex);
        }
    }
}



