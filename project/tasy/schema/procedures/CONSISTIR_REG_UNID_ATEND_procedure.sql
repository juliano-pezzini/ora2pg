-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_reg_unid_atend (nr_seq_interno_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


cd_setor_atendimento_w	bigint;
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w	varchar(10);
ie_possui_reg_w		varchar(1);

BEGIN
if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then
	   select max(cd_setor_atendimento),
		  max(cd_unidade_basica),
		  max(cd_unidade_compl)
	   into STRICT   cd_setor_atendimento_w,
		  cd_unidade_basica_w,
		  cd_unidade_compl_w
	   from   unidade_atendimento
	   where  nr_seq_interno = nr_seq_interno_p;

	  select  CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	  into STRICT    ie_possui_reg_w
	  from    atend_paciente_unidade
	  where   coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
	  and     coalesce(cd_unidade_basica, cd_unidade_basica_w)	= cd_unidade_basica_w
	  and     coalesce(cd_unidade_compl, cd_unidade_compl_w)	= cd_unidade_compl_w;

	  if (ie_possui_reg_w = 'S') then
		ds_erro_p := wheb_mensagem_pck.get_texto(281527,null);
	  else
		ds_erro_p := '';
	  end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_reg_unid_atend (nr_seq_interno_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
