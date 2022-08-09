-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_select_goal (nr_seq_pat_care_plan_p bigint, nr_seq_cp_goal_p bigint, nr_seq_pat_cp_problem_p bigint, nm_usuario_p text, nr_seq_prescr_diag_p bigint default null, nr_seq_patient_cp_goal_out_p INOUT text DEFAULT NULL) AS $body$
DECLARE


nr_seq_patient_cp_goal_out_w	patient_cp_goal.nr_sequencia%type;
si_selected_w					varchar(1)	:= 'N';


BEGIN

SELECT	
    MAX(nr_sequencia) INTO STRICT	nr_seq_patient_cp_goal_out_w
FROM (
    SELECT
        NR_SEQUENCIA
    FROM   	patient_cp_goal b
    WHERE	
        b.nr_seq_cp_goal = nr_seq_cp_goal_p AND	    
        b.nr_seq_pat_care_plan = nr_seq_pat_care_plan_p AND     
        b.nr_seq_pat_cp_problem = nr_seq_pat_cp_problem_p
    
UNION ALL

    SELECT	
        nr_sequencia
    FROM   	patient_cp_goal b
    WHERE	
        b.nr_seq_cp_goal = nr_seq_cp_goal_p AND	    
        coalesce(b.nr_seq_pat_care_plan,0) = coalesce(nr_seq_pat_care_plan_p,0) AND     
        coalesce(b.nr_seq_pat_cp_problem,0) = coalesce(nr_seq_pat_cp_problem_p,0) AND     
        b.nr_seq_prescr_diag = nr_seq_prescr_diag_p
) alias5;

if (coalesce(nr_seq_patient_cp_goal_out_w::text, '') = '') then

	select nextval('patient_cp_goal_seq') into STRICT nr_seq_patient_cp_goal_out_w;

	insert into patient_cp_goal(
				nr_sequencia,
                dt_atualizacao,
				dt_atualizacao_nrec,
				dt_end,
				dt_release,
				dt_start,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_cp_goal,
				nr_seq_pat_care_plan,
				nr_seq_pat_cp_problem,
                nr_seq_prescr_diag,
				si_selected)
	values (nr_seq_patient_cp_goal_out_w,
			clock_timestamp(),
			clock_timestamp(),
			null,
			null,
			null,
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_cp_goal_p,
			nr_seq_pat_care_plan_p,     
			nr_seq_pat_cp_problem_p,
            nr_seq_prescr_diag_p,
			'Y');
else
	
  select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'Y' END
	into STRICT	si_selected_w
	from	patient_cp_indicator a
	where	a.nr_seq_pat_cp_goal = nr_seq_patient_cp_goal_out_w
	and		a.si_selected = 'Y';

	update	patient_cp_goal
	set		si_selected = si_selected_w,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_patient_cp_goal_out_w;

end if;

nr_seq_patient_cp_goal_out_p	:= nr_seq_patient_cp_goal_out_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_select_goal (nr_seq_pat_care_plan_p bigint, nr_seq_cp_goal_p bigint, nr_seq_pat_cp_problem_p bigint, nm_usuario_p text, nr_seq_prescr_diag_p bigint default null, nr_seq_patient_cp_goal_out_p INOUT text DEFAULT NULL) FROM PUBLIC;
