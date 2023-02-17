public without sharing class FlowConfig {
    public static Map<String, Interview> interviews = new Map<String, Interview>{
        'mypage' => new Interview (
            'getMypageEnv',
            new Map<String, Object> {
                'accountId' => 'varAccountId',
                'profileId' => 'varProfileId'
            }
        )
    };

    public static Interview interview(String key) {
        return interviews.get(key);
    }

    class Interview {
        public String name;
        public Map<String, Object> outputVariables;

        public Interview (String name, Map<String, Object> outputVariables) {
            this.name = name;
            this.outputVariables = outputVariables;
        }

        public String name() {
            return this.name;
        }

        public Object outputVariable(String key) {
            return this.outputVariables.get(key);
        }
    }
}
