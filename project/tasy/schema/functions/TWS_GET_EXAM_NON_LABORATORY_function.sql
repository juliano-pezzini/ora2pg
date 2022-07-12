-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tws_get_exam_non_laboratory ( nr_prescription_p bigint, nr_sequence_p bigint, vl_param_status_exam_p bigint, ie_type_p text, nm_user_p text) RETURNS varchar AS $body$
DECLARE


/*
Parameter ie_type_p:
S - Description status
V - Dominio value status
D - Status date
N - Name

Variable: ie_type_status_w
P - Processing
A - Available
R - Ready

ie_date_type_w:
1 - Update
2 - Approval date
3 - Release date
4 - Real delivery
*/
ie_status_w			smallint;
ds_result_w			varchar(80) := '';
ie_type_status_w	varchar(1);
ie_date_type_w		smallint := 0;
dt_status_w			timestamp;
vl_param_approv_w	varchar(2);
vl_approv_status_w	varchar(2);
dt_prev_result_w    timestamp;
vl_break_after_approval bigint := 0;
ie_break_after_approval varchar(1) := 'N';


BEGIN

if (nr_prescription_p IS NOT NULL AND nr_prescription_p::text <> '') and (nr_sequence_p IS NOT NULL AND nr_sequence_p::text <> '') then

		begin
			select	max((ie_status_execucao)::numeric )
			into STRICT	ie_status_w
			from	prescr_procedimento
			where	nr_prescricao		= nr_prescription_p
			and		nr_sequencia		= nr_sequence_p
			and		ie_status_execucao	<> 'BE';
		exception
			when others then
				ie_status_w := 1;
		end;

		if (vl_param_status_exam_p = 35) then

			if (ie_status_w < 35) then
				ie_type_status_w := 'P';
				ie_date_type_w := 1;
			else
				ie_type_status_w := 'A';
				ie_date_type_w := 2;
			end if;

		elsif (vl_param_status_exam_p = 40) then

			if (ie_status_w < 40) then
				ie_type_status_w := 'P';
				ie_date_type_w := 1;
			else
				ie_type_status_w := 'A';
				ie_date_type_w := 3;
			end if;

		elsif (vl_param_status_exam_p = 41) then

			if (ie_status_w < 45) then
				ie_type_status_w := 'P';
				ie_date_type_w := 1;
			else
				ie_type_status_w := 'A';
				ie_date_type_w := 4;
			end if;

		end if;

		if (ie_type_status_w = 'A') then
			vl_param_approv_w := tws_obter_param_tipo_login('1', 9114, 8);
		
			if (vl_param_approv_w = 'S') then
				vl_approv_status_w := tws_get_exam_approval_status(nr_prescription_p, nr_sequence_p, null, null, null, 'N');
				
				if (vl_approv_status_w <> 'S') then
					ie_type_status_w := 'R';
					
				end if;
			end if;

            vl_break_after_approval := Obter_Param_Usuario(99010, 17, 0, 0, wsuite_login_pck.wsuite_data_configuration('CDE'), vl_break_after_approval);

			if (vl_break_after_approval > 0)then
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_break_after_approval
				from	laudo_paciente
				where	nr_prescricao		= nr_prescription_p
				and		nr_seq_prescricao	= nr_sequence_p
				and 	(((dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '') and (dt_aprovacao+(vl_break_after_approval/1440)) > clock_timestamp()) or
							((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') and (dt_liberacao+(vl_break_after_approval/1440)) > clock_timestamp()));

				if (ie_break_after_approval = 'S') then
					ie_type_status_w := 'P';
					ie_date_type_w := 1;
				end if;
			end if;
		end if;

		if (ie_type_p = 'V') then

			ds_result_w := ie_type_status_w;

		elsif (ie_type_p = 'S') then

      select	substr(wsuite_util_pck.get_wsuite_expression(cd_exp_valor_dominio),1,80)
			into STRICT	ds_result_w
			from	valor_dominio_v
			where	cd_dominio 	= 8310
			and		vl_dominio	= ie_type_status_w;


		elsif (ie_type_p = 'D') then

			if (ie_date_type_w = 1) then

                select max(CASE WHEN(SELECT max(IE_CONSIDERA_ANTECIPACAO) FROM PARAMETRO_CDI)='S' THEN  coalesce(a.dt_antecipa_result,a.dt_resultado)  ELSE a.dt_resultado END ) as dt_prev_entrega
                into STRICT dt_prev_result_w
                from	prescr_procedimento a
                where	a.nr_prescricao	= nr_prescription_p
				and		a.nr_sequencia	= nr_sequence_p;

				select	coalesce(dt_prev_result_w, max(c.dt_liberacao))
				into STRICT	dt_status_w
				from	prescr_procedimento a,
                        prescr_medica c
				where	a.nr_prescricao	= nr_prescription_p
                and     a.nr_prescricao = c.nr_prescricao
				and		a.nr_sequencia	= nr_sequence_p;

			elsif (ie_date_type_w = 2) then

				select	coalesce(max(dt_aprovacao), max(dt_liberacao))
				into STRICT	dt_status_w
				from	laudo_paciente
				where	nr_prescricao		= nr_prescription_p
				and		nr_seq_prescricao	= nr_sequence_p;

			elsif (ie_date_type_w = 3) then

				select	max(dt_liberacao)
				into STRICT	dt_status_w
				from	laudo_paciente
				where	nr_prescricao		= nr_prescription_p
				and		nr_seq_prescricao	= nr_sequence_p;

			elsif (ie_date_type_w = 4) then

				select	max(dt_real_entrega)
				into STRICT	dt_status_w
				from	laudo_paciente
				where	nr_prescricao		= nr_prescription_p
				and		nr_seq_prescricao	= nr_sequence_p;

			end if;

			if (dt_status_w IS NOT NULL AND dt_status_w::text <> '') then

				ds_result_w :=  pkg_date_formaters.to_varchar(dt_status_w, 'yyyy-MM-dd HH:mm:ss','NLS_DATE_LANGUAGE=portuguese');
				
			end if;

		elsif (ie_type_p = 'N') then

			select	substr(coalesce(obter_desc_proc_interno(nr_seq_proc_interno),obter_desc_procedimento(cd_procedimento,ie_origem_proced)),1,80)
			into STRICT	ds_result_w
			from	prescr_procedimento
			where	nr_prescricao		= nr_prescription_p
			and		nr_sequencia		= nr_sequence_p;

		end if;

end if;

return ds_result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tws_get_exam_non_laboratory ( nr_prescription_p bigint, nr_sequence_p bigint, vl_param_status_exam_p bigint, ie_type_p text, nm_user_p text) FROM PUBLIC;

