-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovar_proposta_aquisicao ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_usuario_destino_w			varchar(15);
nm_usuario_origem_w			varchar(15);
nm_solicitante_proposta_w		varchar(255);
nm_aprovador_w				varchar(255);
ds_comunicado_w				varchar(4000);
nr_seq_classif_w			bigint;
nr_solic_compra_w			bigint;
nr_seq_comunic_w			bigint;
					

BEGIN 
 
select	obter_usuario_pessoa(cd_solicitante_proposta) nm_usuario_destino, 
	obter_usuario_pessoa(cd_aprovador) nm_usuario_origem,	 
	substr(obter_nome_pf(cd_solicitante_proposta),1,255), 
	substr(obter_nome_pf(cd_aprovador),1,255), 
	nr_solic_compra 
into STRICT	nm_usuario_destino_w, 
	nm_usuario_origem_w, 
	nm_solicitante_proposta_w, 
	nm_aprovador_w, 
	nr_solic_compra_w 
from	solic_compra_proposta 
where	nr_sequencia = nr_sequencia_p;
 
update	solic_compra_proposta 
set	dt_aprovacao	= clock_timestamp() 
where	nr_sequencia	= nr_sequencia_p;
 
select	obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
ds_comunicado_w	:=	substr( wheb_mensagem_pck.get_texto(297386, 
				'NM_SOLICITANTE='||nm_solicitante_proposta_w|| 
				';NR_SOLIC_COMPRA='||nr_solic_compra_w|| 
				';NM_APROVADOR='||nm_aprovador_w),1,4000);
 
				 
select	nextval('comunic_interna_seq') 
into STRICT	nr_seq_comunic_w
;
 
insert into comunic_interna( 
	dt_comunicado, 
	ds_titulo, 
	ds_comunicado, 
	nm_usuario, 
	dt_atualizacao, 
	ie_geral, 
	nm_usuario_destino, 
	nr_sequencia, 
	ie_gerencial, 
	nr_seq_classif, 
	dt_liberacao, 
	ds_perfil_adicional, 
	ds_setor_adicional) 
values (	clock_timestamp(), 
	/*Aprovação da proposta aquisição*/
 
	wheb_mensagem_pck.get_texto(297387), 
	ds_comunicado_w, 
	nm_usuario_origem_w, 
	clock_timestamp(), 
	'N', 
	nm_usuario_destino_w, 
	nr_seq_comunic_w, 
	'N', 
	nr_seq_classif_w, 
	clock_timestamp(), 
	'', 
	'');
				 
insert into comunic_interna_lida( 
	nr_sequencia, 
	nm_usuario, 
	dt_atualizacao) 
values (	nr_seq_comunic_w, 
	nm_usuario_origem_w, 
	clock_timestamp());
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovar_proposta_aquisicao ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

