-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_conta_etapa ( nr_interno_conta_p bigint, nm_usuario_p text, nr_seq_etapa_p bigint, cd_setor_atendimento_p bigint, cd_motivo_devol_p text, cd_pessoa_fisica_p text, ds_observacao_p text, nr_lote_barras_p bigint, nr_seq_prot_documento_p bigint, ie_conta_existe_p INOUT text) AS $body$
DECLARE

 
nr_sequencia_w		bigint:= '';
dt_etapa_w		timestamp := clock_timestamp();
ie_conta_existe_w	varchar(1);
cd_estab_etapa_w	integer;
cd_estab_conta_w	integer;
ie_estab_etapa_conta_w	varchar(15) := 'N';
ie_permite_nova_etapa_w	varchar(2);


BEGIN 
 
cd_estab_conta_w := substr(Obter_Estab_Conta_Paciente(nr_interno_conta_p),1,5);
 
ie_estab_etapa_conta_w := obter_param_usuario(1121, 21, obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_estab_etapa_conta_w);
	 
if (coalesce(obter_valor_param_usuario(67, 249, obter_perfil_ativo, nm_usuario_p, cd_estab_conta_w),'N') = 'S') then 
 
	select	coalesce(max(dt_entrada_unidade), clock_timestamp()) 
	into STRICT	dt_etapa_w 
	from	atend_paciente_unidade 
	where	nr_atendimento	= obter_atendimento_conta(nr_interno_conta_p);
end if;
 
select	max(cd_estabelecimento) 
into STRICT	cd_estab_etapa_w 
from	fatur_etapa 
where	nr_sequencia = nr_seq_etapa_p;
 
if (cd_estab_conta_w <> cd_estab_etapa_w) and (coalesce(ie_estab_etapa_conta_w,'N') = 'S') then 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(233663);
	/*'Não é permitido inserir esta etapa na conta, pois o estabelecimento da etapa não é o mesmo da conta!' || chr(13) || 
					'Verifique o parâmetro[21], da função EIS contas pendentes (Nova).');*/
 
end if;
 
select	coalesce(max('S'),'N') 
into STRICT	ie_conta_existe_w 
from	conta_paciente 
where	nr_interno_conta = nr_interno_conta_p;
 
select	coalesce(max(obter_permite_nova_etapa(nr_interno_conta_p)), 'S') 
into STRICT	ie_permite_nova_etapa_w
;
 
if (ie_conta_existe_w = 'S') and (ie_permite_nova_etapa_w = 'S') then 
 
	select	nextval('conta_paciente_etapa_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert into conta_paciente_etapa( 
		nr_sequencia, 
		nr_interno_conta, 
		dt_atualizacao, 
		nm_usuario, 
		dt_etapa, 
		nr_seq_etapa, 
		cd_setor_atendimento, 
		cd_pessoa_fisica, 
		nr_seq_motivo_dev, 
		ds_observacao, 
		nr_lote_barras, 
		nr_seq_prot_documento, 
		NM_USUARIO_NREC, 
		DT_ATUALIZACAO_NREC) 
	values (nr_sequencia_w, 
		nr_interno_conta_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_etapa_w, 
		nr_seq_etapa_p, 
		CASE WHEN cd_setor_atendimento_p=0 THEN null  ELSE cd_setor_atendimento_p END , 
		cd_pessoa_fisica_p, 
		CASE WHEN cd_motivo_devol_p='0' THEN null  ELSE cd_motivo_devol_p END , 
		ds_observacao_p || ' - ' || to_char(nr_seq_prot_documento_p), 
		nr_lote_barras_p, 
		nr_seq_prot_documento_p, 
		nm_usuario_p, 
		clock_timestamp());
 
	CALL Atualiza_Final_Etapa_Conta(nr_sequencia_w, nm_usuario_p);
 
 
	commit;
end if;
 
ie_conta_existe_p := ie_conta_existe_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_conta_etapa ( nr_interno_conta_p bigint, nm_usuario_p text, nr_seq_etapa_p bigint, cd_setor_atendimento_p bigint, cd_motivo_devol_p text, cd_pessoa_fisica_p text, ds_observacao_p text, nr_lote_barras_p bigint, nr_seq_prot_documento_p bigint, ie_conta_existe_p INOUT text) FROM PUBLIC;
