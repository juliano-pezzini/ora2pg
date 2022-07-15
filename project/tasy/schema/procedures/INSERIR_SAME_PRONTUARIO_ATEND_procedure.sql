-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_same_prontuario_atend (nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_utiliza_regra_setor_w	varchar(1);
nr_seq_local_w			bigint;	
ie_tipo_w			varchar(5);	
ie_preenche_local_same_w	varchar(1);
cd_pessoa_fisica_w		varchar(10);

BEGIN
ie_utiliza_regra_setor_w := obter_param_usuario(941, 72, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_utiliza_regra_setor_w);
ie_preenche_local_same_w := obter_param_usuario(941, 20, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_preenche_local_same_w);
 
if (ie_utiliza_regra_setor_w = 'S') then 
	SELECT * FROM Obter_Tipo_Local_regra(nr_atendimento_p, nr_seq_local_w, ie_tipo_w) INTO STRICT nr_seq_local_w, ie_tipo_w;
end if;
 
if (ie_preenche_local_same_w = 'S') and (coalesce(nr_seq_local_w::text, '') = '') then 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_local_w 
	from	same_local 
	where	ie_situacao = 'A' 
	and	ie_local_base = 'S';
end if;
 
select	max(cd_pessoa_fisica) 
into STRICT	cd_pessoa_fisica_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
CALL Inserir_prontuario_same(coalesce(ie_tipo_w,1),cd_pessoa_fisica_w,nr_atendimento_p,null,wheb_usuario_pck.get_cd_setor_atendimento,nr_seq_local_w,cd_estabelecimento_p,nm_usuario_p,null,null,null);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_same_prontuario_atend (nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

