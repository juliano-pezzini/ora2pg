-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE acertar_duplic_med_tiss_cbo (cd_pessoa_origem_p text, cd_pessoa_destino_p text) AS $body$
DECLARE

									
ie_param_45	varchar(1) := 'N';

BEGIN

 insert into TISS_CBO_SAUDE(
        nr_sequencia,					
        dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cbo_saude,
				ie_versao,
				cd_pessoa_fisica,
				cd_especialidade,
				cd_convenio
        )
    SELECT	nextval('tiss_cbo_saude_seq'),
       clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				nr_seq_cbo_saude,
				ie_versao,
				cd_pessoa_destino_p,
				cd_especialidade,
				null
    from 	TISS_CBO_SAUDE a
    where	a.cd_pessoa_fisica = cd_pessoa_origem_p
    and		not exists (	SELECT	1
              from 	TISS_CBO_SAUDE x 
              where 	x.cd_pessoa_fisica	= cd_pessoa_destino_p
              and		x.IE_VERSAO = a.IE_VERSAO
              and		x.NR_SEQ_CBO_SAUDE = a.NR_SEQ_CBO_SAUDE);
					
ie_param_45 := obter_param_usuario(4, 45, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_45);

if (ie_param_45 = 'N')then
  delete	
  from TISS_CBO_SAUDE
  where	cd_pessoa_fisica = cd_pessoa_origem_p;
else
  delete	
  from TISS_CBO_SAUDE
  where	cd_pessoa_fisica = cd_pessoa_origem_p;
  delete
  from	medico_especialidade
  where	cd_pessoa_fisica = cd_pessoa_origem_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE acertar_duplic_med_tiss_cbo (cd_pessoa_origem_p text, cd_pessoa_destino_p text) FROM PUBLIC;

