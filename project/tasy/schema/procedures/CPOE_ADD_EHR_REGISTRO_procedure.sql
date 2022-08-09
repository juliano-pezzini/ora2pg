-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_add_ehr_registro (nr_seq_template_p ehr_registro.nr_seq_templ%type, cd_pessoa_fisica_p ehr_registro.cd_paciente%type, cd_profissional_p ehr_registro.cd_profissional%type, nm_usuario_p ehr_registro.nm_usuario%type, nr_atendimento_p ehr_registro.nr_atendimento%type, nr_sequencia_p INOUT ehr_registro.nr_sequencia%type, nr_seq_anatomy_p cpoe_anatomia_patologica.nr_sequencia%type) AS $body$
DECLARE


nr_sequencia_ehr_w ehr_registro.nr_sequencia%type;


BEGIN

        nr_sequencia_ehr_w := null;

        select max(nr_sequencia)
        into STRICT nr_sequencia_ehr_w
        from ehr_registro
        where nr_seq_proc_cpoe = nr_seq_anatomy_p
        and nr_seq_templ = nr_seq_template_p
        and (nr_seq_proc_cpoe IS NOT NULL AND nr_seq_proc_cpoe::text <> '');


        if (nr_sequencia_ehr_w IS NOT NULL AND nr_sequencia_ehr_w::text <> '')
        then 
                nr_sequencia_p :=  nr_sequencia_ehr_w;
        else
                select nextval('ehr_registro_seq')
                into STRICT nr_sequencia_p
;

                insert into ehr_registro(nr_sequencia,
                nr_seq_templ,
                cd_paciente,
                cd_profissional,
                dt_atualizacao,
                nm_usuario,
                nm_usuario_nrec,
                dt_atualizacao_nrec,
                dt_registro,
                nr_atendimento,
                ie_avaliador_aux,
                ie_nivel_atencao,
                nr_seq_proc_cpoe
                )
                values (nr_sequencia_p,
                nr_seq_template_p,
                cd_pessoa_fisica_p,
                cd_profissional_p,
                clock_timestamp(),
                nm_usuario_p,
                nm_usuario_p,
                clock_timestamp(),
                clock_timestamp(),
                nr_atendimento_p,
                'N',
                'T',
                nr_seq_anatomy_p);

                CALL ehr_gerar_reg_template(nr_sequencia_p, nr_seq_template_p, nm_usuario_p);
        end if;

        nr_sequencia_p := ehr_obter_reg_template(nr_sequencia_p, 'R');
	-- NR_SEQ_REG_TEMPLATE_W := ehr_obter_reg_template(nr_sequencia_p, 'T');
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_add_ehr_registro (nr_seq_template_p ehr_registro.nr_seq_templ%type, cd_pessoa_fisica_p ehr_registro.cd_paciente%type, cd_profissional_p ehr_registro.cd_profissional%type, nm_usuario_p ehr_registro.nm_usuario%type, nr_atendimento_p ehr_registro.nr_atendimento%type, nr_sequencia_p INOUT ehr_registro.nr_sequencia%type, nr_seq_anatomy_p cpoe_anatomia_patologica.nr_sequencia%type) FROM PUBLIC;
