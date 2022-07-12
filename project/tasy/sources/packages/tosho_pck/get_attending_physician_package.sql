-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


        
    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	fetch the attending physician details
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    **/
  


CREATE OR REPLACE FUNCTION tosho_pck.get_attending_physician (nr_atendimento_p text) RETURNS varchar AS $body$
DECLARE

    physician_code_w varchar(20);

BEGIN
            select max(coalesce(b.cd_profissional,0))
            into STRICT physician_code_w
            from funcao_medico a,
                atend_paciente_medico b
            where b.nr_atendimento = nr_atendimento_p
            and a.cd_funcao   = b.nr_seq_func_medico
            and a.ie_medico   = 'S'
            and a.ie_auxiliar = 'N';

            return physician_code_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tosho_pck.get_attending_physician (nr_atendimento_p text) FROM PUBLIC;