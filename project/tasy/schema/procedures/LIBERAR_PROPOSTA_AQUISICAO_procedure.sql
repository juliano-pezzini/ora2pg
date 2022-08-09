-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_proposta_aquisicao ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
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
 
select	obter_usuario_pessoa(cd_solicitante_proposta) nm_usuario_origem, 
	obter_usuario_pessoa(cd_aprovador) nm_usuario_destino,	 
	substr(obter_nome_pf(cd_solicitante_proposta),1,255), 
	substr(obter_nome_pf(cd_aprovador),1,255), 
	nr_solic_compra 
into STRICT	nm_usuario_origem_w, 
	nm_usuario_destino_w, 
	nm_solicitante_proposta_w, 
	nm_aprovador_w, 
	nr_solic_compra_w 
from	solic_compra_proposta 
where	nr_sequencia = nr_sequencia_p;
 
update	solic_compra_proposta 
set	dt_liberacao	= clock_timestamp(), 
	nm_usuario_lib	= nm_usuario_p 
where	nr_sequencia	= nr_sequencia_p;
 
select	obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
ds_comunicado_w	:=	substr(WHEB_MENSAGEM_PCK.get_texto(303076,'NM_APROVADOR_W='|| NM_APROVADOR_W ||';NR_SOLIC_COMPRA_W='|| NR_SOLIC_COMPRA_W),1,4000);
			/*substr(	'Prezado ' || nm_aprovador_w || ',' || chr(13) || chr(10) || 
				'Existe uma nova proposta de aquisição da solicitação de compras número ' || nr_solic_compra_w || ' para a sua análise.' || chr(13) || chr(10) || 
				'Essa proposta se encontra na pasta Proposta aquisição da função Solicitação de compras.' || chr(13) || chr(10) || chr(13) || chr(10) || 
				'Atenciosamente, ' || chr(13) || chr(10) || 
				nm_solicitante_proposta_w,1,4000);*/
 
 
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
	Wheb_mensagem_pck.get_Texto(303077), /*'Nova proposta aquisição para análise',*/
 
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
-- REVOKE ALL ON PROCEDURE liberar_proposta_aquisicao ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
