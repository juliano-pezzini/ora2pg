-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_laudo_aih ( nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

			 
nr_atendimento_w	bigint;
cd_procedimento_w	bigint;
cd_cid_principal_w	varchar(4);
ds_erro_w		varchar(255);
qt_cid_Obrig_w		smallint	:= 0;
qt_cid_Igual_w		smallint	:= 0;


BEGIN 
 
if (nr_sequencia_p	> 0) then 
 
	/* obter dados do laudo	*/
 
	select	nr_atendimento, 
		cd_procedimento_solic, 
		cd_cid_principal 
	into STRICT	nr_atendimento_w, 
	 	cd_procedimento_w, 
	 	cd_cid_principal_w 
	from	sus_laudo_paciente 
	where	nr_seq_interno	= nr_sequencia_p;
 
	/* Procedimento Não Compativel com CID Principal*/
 
	select	coalesce(count(*),0), 
		coalesce(sum(CASE WHEN cd_doenca_cid=cd_cid_principal_w THEN 1  ELSE 0 END ),0) 
	into STRICT	qt_cid_obrig_w, 
		qt_cid_igual_w 
	from	sus_proced_doenca 
	where	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= 2;
 
	if (qt_cid_obrig_w > 0) and (qt_cid_igual_w = 0) then 
		ds_erro_w	:= ds_erro_w || '768 ';
	end if;
 
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
		begin 
		update	sus_laudo_paciente 
		set	ds_inconsistencia	= ds_erro_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao	 	= clock_timestamp() 
		where	nr_seq_interno	 	= nr_sequencia_p;
		commit;
		end;
	end if;
end if;
 
ds_erro_p	:= ds_erro_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_laudo_aih ( nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
