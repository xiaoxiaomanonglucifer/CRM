package per.zpp.workbench.domain;

public class ClueActivityRelation {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.clue_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    private String clueId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.activity_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    private String activityId;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public ClueActivityRelation(String id, String clueId, String activityId) {
        this.id = id;
        this.clueId = clueId;
        this.activityId = activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public ClueActivityRelation() {
        super();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.id
     *
     * @return the value of tbl_clue_activity_relation.id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.id
     *
     * @param id the value for tbl_clue_activity_relation.id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @return the value of tbl_clue_activity_relation.clue_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public String getClueId() {
        return clueId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @param clueId the value for tbl_clue_activity_relation.clue_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public void setClueId(String clueId) {
        this.clueId = clueId == null ? null : clueId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @return the value of tbl_clue_activity_relation.activity_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public String getActivityId() {
        return activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @param activityId the value for tbl_clue_activity_relation.activity_id
     *
     * @mbggenerated Thu Aug 03 15:12:56 CST 2023
     */
    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }
}