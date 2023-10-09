enum ResultPackage {
    internship, workingStudent, trainee
}

class ResultPackageHelper {
    String getValue(ResultPackage resultPackage) {
        switch(resultPackage){
            case ResultPackage.internship:
                return 'Praktikum';
            case ResultPackage.workingStudent:
                return 'Werksstudent';
            case ResultPackage.trainee:
                return 'Trainee';
            default:
                return '';
        }
    }
}

