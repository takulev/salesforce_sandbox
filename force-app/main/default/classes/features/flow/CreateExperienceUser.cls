global with sharing class CreateExperienceUser {
    @InvocableMethod(label='Experienceユーザー作成' description='Experienceユーザーを作成する関数')
    global static void createUser() {

    }

    global class InputCreateExperienceUser {
        @InvocableVariable(description='')
        global Integer contactId;

        @InvocableVariable(description='')
        global Integer talentActivityId;
    }
}
