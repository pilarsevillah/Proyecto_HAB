require("dotenv").config();
const getDB = require("./db");

main();


async function main() {
    try{
        connection = await getDB();
        await dropDatabaseContent();

    } catch (error) {
        console.error(error);
    } finally {
        if (connection) connection.release();
        process.exit();
    }
};

async function dropDatabaseContent() {
    const QUERIES = [
        //      VIEWS
        "DROP VIEW IF EXISTS \`question_header\`\;",
        "DROP VIEW IF EXISTS \`languages_page\`\;",

        //      PROCEDURES
        "DROP PROCEDURE IF EXISTS \`updateUserLanguageReputation\`\;",
        "DROP PROCEDURE IF EXISTS \`updateUserPlatformReputation\`\;",
        "DROP PROCEDURE IF EXISTS \`updateLanguageReputation\`\;",
        "DROP PROCEDURE IF EXISTS \`updatePlatformReputation\`\;",
        "DROP PROCEDURE IF EXISTS \`removeSelectedAvatarsFromUser\`\;",
        "DROP PROCEDURE IF EXISTS \`getCommentsOf\`\;",
        "DROP PROCEDURE IF EXISTS \`getAnswersOfQuestion\`\;",

        //      FUNCTIONS
        "DROP FUNCTION IF EXISTS \`hasValidatedAnswers\`\;",
        "DROP FUNCTION IF EXISTS \`getQuestionAnswersCount\`\;",
        "DROP FUNCTION IF EXISTS \`getQuestionAnswers\`\;",
        "DROP FUNCTION IF EXISTS \`getNumLanguageQuestionsWeek\`\;",
        "DROP FUNCTION IF EXISTS \`getNumLanguageQuestionsToday\`\;",
        "DROP FUNCTION IF EXISTS \`getContentVotes\`\;",
        "DROP FUNCTION IF EXISTS \`generateAvatarID\`\;",

        //      EVENTS
        "DROP EVENT IF EXISTS \`reduceReputationDaily\`;",

        //      TABLES
        
        "DROP TABLE IF EXISTS \`avatar\`\;",
        "DROP TABLE IF EXISTS \`user-language\`\;",
        "DROP TABLE IF EXISTS \`answer\`\;",
        "DROP TABLE IF EXISTS \`comment\`\;",
        "DROP TABLE IF EXISTS \`vote\`\;",
        "DROP TABLE IF EXISTS \`question_close_reason\`\;",
        "DROP TABLE IF EXISTS \`question_closed\`\;",
        "DROP TABLE IF EXISTS \`question_content\`\;",
        "DROP TABLE IF EXISTS \`question\`\;",
        "DROP TABLE IF EXISTS \`language\`\;",
        "DROP TABLE IF EXISTS \`user\`\;"
        
        
    ];

    await executeTransaction(QUERIES);
}

async function executeTransaction(queryArray) {
    try {
        await connection.query("START TRANSACTION");
        for (let i = 0; i < queryArray.length; i++) {
            await connection.query(queryArray[i]);
        }
        await connection.query("COMMIT");
    } catch (err) {
        await connection.query("ROLLBACK");
        throw err;
    }
}
