-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_ley_prov_patient_acc ( nr_interno_conta_p conta_paciente.nr_interno_conta%type ) AS $body$
DECLARE


	json_data_w	    	  PHILIPS_JSON;
	json_PCM			  PHILIPS_JSON;
	json_PCM_List   	  PHILIPS_JSON_LIST;
	json_PatProc		  PHILIPS_JSON;
	json_PatProc_List	  PHILIPS_JSON_LIST;
	data_w				  text;
    nr_interno_conta_w    conta_paciente.nr_interno_conta%type := nr_interno_conta_p;
    bifrost_log_error_w   bifrost_layer_log.ds_message_error%type;
    vl_tipo_atendimento_w constant integer := 12;
    vl_transplante_w      constant integer := 10415;
    vl_erro_w             constant conta_paciente.ie_integration%type := 'E';
    vl_enviado_w          constant conta_paciente.ie_integration%type := 'V';
    nm_leyprovacc_w       constant bifrost_layer_log.nm_event%type := 'leyprovincialaccount.post.outbound';


patientAccount CURSOR FOR
	SELECT  d.nr_interno_conta,
            a.nr_interno_conta nr_conta_origem,
            a.cd_estabelecimento,
            f.sg_estado,
			OBTER_VALOR_DOMINIO(vl_tipo_atendimento_w, b.ie_tipo_atendimento) as ie_tipo_atendimento,
			OBTER_VALOR_DOMINIO(vl_transplante_w, c.ie_transplante) as ie_transplante,
            a.vl_conta
    FROM    conta_paciente a,
            atendimento_paciente b,
            atendimento_paciente_inf c,
            conta_paciente d,
            estabelecimento e,
            pessoa_juridica f
    WHERE   b.nr_atendimento = a.nr_atendimento
    and     c.nr_atendimento = b.nr_atendimento
    and     d.nr_conta_lei_prov = a.nr_interno_conta
    and     e.cd_estabelecimento = a.cd_estabelecimento
    and     f.cd_cgc = e.cd_cgc
    and     a.nr_interno_conta = nr_interno_conta_w;

patientCareMaterial CURSOR FOR
    SELECT  cd_material,
			qt_material,
            vl_material
    FROM    material_atend_paciente
    WHERE   nr_interno_conta = nr_interno_conta_w;

patientProcedure CURSOR FOR
    SELECT  a.cd_procedimento,
            b.cd_procedimento_loc,
            a.qt_procedimento,
            a.vl_procedimento
    FROM    procedimento_paciente a,
            procedimento b
    WHERE   b.cd_procedimento = a.cd_procedimento
    AND     b.ie_origem_proced = a.ie_origem_proced
    AND     a.nr_interno_conta =  nr_interno_conta_w;
BEGIN
	json_data_w := philips_json();

    <<patAccLoop>>    
	FOR patAcc IN patientAccount LOOP
		json_data_w.put('accountId', patAcc.nr_interno_conta);
		json_data_w.put('originalAccount', patAcc.nr_conta_origem);
		json_data_w.put('establishment', patAcc.cd_estabelecimento);
		json_data_w.put('province', patAcc.sg_estado);
		json_data_w.put('hospitalization', patAcc.ie_tipo_atendimento);
		json_data_w.put('transplant', patAcc.ie_transplante);
		json_data_w.put('accountValue', patAcc.vl_conta);
	END LOOP patAccLoop;

    <<patCarMatBegin>>
	BEGIN
        json_PCM := philips_json();
		json_PCM_List := philips_json_list();

        <<patCarMatLoop>>
		FOR patCarMat IN patientCareMaterial LOOP
			json_PCM.put('materialCode', patCarMat.cd_material);
			json_PCM.put('materialAmount', patCarMat.qt_material);
			json_PCM.put('materialValue', patCarMat.vl_material);

			json_PCM_List.APPEND(json_PCM.to_json_value());
		END LOOP patCarMatLoop;

		json_data_w.put('materials', json_PCM_List.to_json_value());
	END;

    <<patProcBegin>>
	BEGIN
        json_PatProc := philips_json();
		json_PatProc_List := philips_json_list();

		<<patProcLoop>>
        FOR patProc IN patientProcedure LOOP
			json_PatProc.put('procedureCode', patProc.cd_procedimento);
			json_PatProc.put('procedureCodeLoc', patProc.cd_procedimento_loc);
			json_PatProc.put('procedureAmount', patProc.qt_procedimento);
			json_PatProc.put('procedureValue', patProc.vl_procedimento);

			json_PatProc_List.APPEND(json_PatProc.to_json_value());
		END LOOP patProcLoop;

		json_data_w.put('procedures', json_PatProc_List.to_json_value());
	END;

	dbms_lob.createtemporary(data_w, true);
    json_data_w.(data_w);
    data_w := bifrost.send_integration_content(nm_leyprovacc_w, data_w, wheb_usuario_pck.get_nm_usuario);

    <<BiforstLogErro>>
    begin
        select  ds_message_error
        into STRICT    bifrost_log_error_w
        from    bifrost_layer_log
        where   nr_sequence in (SELECT max(b.nr_sequence) from bifrost_layer_log b where b.nm_event = nm_leyprovacc_w)
        order by dt_integration desc;
    EXCEPTION
        WHEN no_data_found THEN null;
        WHEN too_many_rows THEN raise;
    END;

    if (bifrost_log_error_w IS NOT NULL AND bifrost_log_error_w::text <> '') then 
        update conta_paciente
        set     ie_integration = vl_erro_w
        where   nr_conta_lei_prov = nr_interno_conta_w;
    else
        update conta_paciente
        set     ie_integration = vl_enviado_w
        where   nr_conta_lei_prov = nr_interno_conta_w;
    end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_ley_prov_patient_acc ( nr_interno_conta_p conta_paciente.nr_interno_conta%type ) FROM PUBLIC;

