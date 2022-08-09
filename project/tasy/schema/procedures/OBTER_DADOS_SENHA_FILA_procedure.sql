-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_senha_fila ( nr_atendimento_p bigint, dt_senha_p INOUT timestamp, ds_senha_p INOUT text) AS $body$
DECLARE

 
nr_seq_pac_senha_fila_w	bigint;
ie_tipo_data_w		varchar(1);
				

BEGIN 
 
if (coalesce(nr_atendimento_p,0) > 0) then 
 
	select	coalesce(max(nr_seq_pac_senha_fila),0) 
	into STRICT	nr_seq_pac_senha_fila_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	if (nr_seq_pac_senha_fila_w > 0) then 
	 
		ie_tipo_data_w := obter_param_usuario(10021, 47, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_tipo_data_w);
	 
		select	substr(obter_letra_verifacao_senha(nr_seq_fila_senha) || cd_senha_gerada,1,20), 
			CASE WHEN ie_tipo_data_w='G' THEN dt_geracao_senha  ELSE dt_primeira_chamada END    
		into STRICT	ds_senha_p, 
			dt_senha_p 
		from	paciente_senha_fila 
		where	nr_sequencia	= nr_seq_pac_senha_fila_w;
	 
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_senha_fila ( nr_atendimento_p bigint, dt_senha_p INOUT timestamp, ds_senha_p INOUT text) FROM PUBLIC;
