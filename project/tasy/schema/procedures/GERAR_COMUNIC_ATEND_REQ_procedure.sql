-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comunic_atend_req ( nr_requisicao_material_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
cd_requisitante_w			bigint;
dt_aprovacao_w			timestamp;
dt_liberacao_w			timestamp;
nm_pessoa_requisitante_w		varchar(60);
dt_solic_req_w			timestamp;
ds_destinatario_w			varchar(255);
ds_solicitante_w			varchar(255);
ds_comunicacao_w			varchar(4000) := '';
ds_titulo_w			varchar(80);
cd_material_w			integer;
cd_motivo_baixa_w			bigint;
qt_material_requisitada_w 		double precision;
qt_material_atendida_w		double precision;
ds_quebra_linha_w			varchar(10) := ' \par ';
cd_estabelecimento_w		smallint;
nr_sequencia_w			bigint;
nr_seq_classif_w			bigint;
nr_requisicao_w			bigint;
ds_justificativa_w			varchar(255);
nr_seq_justificativa_w		item_requisicao_material.nr_seq_justificativa%type;
ds_justificativa_item_w		motivo_justif_req.ds_motivo%type;

C01 CURSOR FOR 
	SELECT	a.cd_material, 
		a.cd_motivo_baixa, 
		a.qt_material_requisitada, 
		a.qt_material_atendida, 
		a.ds_justificativa_atend, 
		a.nr_seq_justificativa 
	from	item_requisicao_material a 
	where	a.nr_requisicao = nr_requisicao_material_p 
	order by a.cd_material;

BEGIN
 
select	a.nr_requisicao, 
	a.cd_pessoa_requisitante, 
	a.dt_aprovacao, 
	a.dt_liberacao, 
	a.dt_solicitacao_requisicao, 
	a.cd_estabelecimento, 
	substr(OBTER_USUARIO_PESSOA(a.cd_pessoa_requisitante),1,255), 
	substr(obter_nome_pf(a.cd_pessoa_solicitante),1,255) 
into STRICT	nr_requisicao_w, 
	cd_requisitante_w, 
	dt_aprovacao_w, 
	dt_liberacao_w, 
	dt_solic_req_w, 
	cd_estabelecimento_w, 
	ds_destinatario_w, 
	ds_solicitante_w 
from	requisicao_material a 
where	a.nr_requisicao = nr_requisicao_material_p;
select	nextval('comunic_interna_seq') 
into STRICT	nr_sequencia_w
;
select	obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
nm_pessoa_requisitante_w:= substr(obter_nome_pf(cd_requisitante_w),1,80);
 
ds_titulo_w		:= WHEB_MENSAGEM_PCK.get_texto(301404,'NR_REQUISICAO_W=' || nr_requisicao_w);
ds_comunicacao_W	:= substr(ds_comunicacao_W || '{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fmodern\fprq1\fcharset0 Courier New;}{\f1\fswiss\fcharset0 Arial;}} 
{\*\generator Msftedit 5.41.21.2500;}\viewkind4\uc1\pard\lang1046\f0\fs20 ' || WHEB_MENSAGEM_PCK.get_texto(333213) || ' ' || nr_requisicao_w || ds_quebra_linha_w || ds_quebra_linha_w,1,4000);
ds_comunicacao_W	:= substr(ds_comunicacao_W || rpad(WHEB_MENSAGEM_PCK.get_texto(333214),40) || rpad(WHEB_MENSAGEM_PCK.get_texto(333215),11) || rpad(WHEB_MENSAGEM_PCK.get_texto(333216),11) || rpad(WHEB_MENSAGEM_PCK.get_texto(333217),11) || ds_quebra_linha_w,1,4000);
ds_comunicacao_W	:= substr(ds_comunicacao_w || rpad(nm_pessoa_requisitante_w,40) || 
		rpad(coalesce(PKG_DATE_FORMATERS.to_varchar(dt_aprovacao_w, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p),' '),11) || 
		rpad(coalesce(PKG_DATE_FORMATERS.to_varchar(dt_liberacao_w, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p),' '),11) || 
		rpad(coalesce(PKG_DATE_FORMATERS.to_varchar(dt_solic_req_w, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p),' '),11) || ds_quebra_linha_w || ds_quebra_linha_w,1,4000);
 
if (coalesce(ds_solicitante_w,'X') <> 'X') then 
	ds_comunicacao_W	:= substr(ds_comunicacao_W || rpad(WHEB_MENSAGEM_PCK.get_texto(333214),40) || rpad(WHEB_MENSAGEM_PCK.get_texto(333215),11) || rpad(WHEB_MENSAGEM_PCK.get_texto(333216),11) || rpad(WHEB_MENSAGEM_PCK.get_texto(333217),11) || ds_quebra_linha_w,1,4000);
	ds_comunicacao_W	:= substr(ds_comunicacao_w || rpad(ds_solicitante_w,40) || ds_quebra_linha_w || ds_quebra_linha_w,1,4000);
end if;
 
ds_comunicacao_W	:= substr(ds_comunicacao_w || rpad(WHEB_MENSAGEM_PCK.get_texto(333218),7) || rpad(WHEB_MENSAGEM_PCK.get_texto(333219),36) || rpad(WHEB_MENSAGEM_PCK.get_texto(333220),20) || rpad(WHEB_MENSAGEM_PCK.get_texto(333221),10) || rpad(WHEB_MENSAGEM_PCK.get_texto(333222),10) || ds_quebra_linha_w,1,4000);
 
open C01;
loop 
fetch C01 into 
	cd_material_w, 
	cd_motivo_baixa_w, 
	qt_material_requisitada_w, 
	qt_material_atendida_w, 
	ds_justificativa_w, 
	nr_seq_justificativa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (nr_seq_justificativa_w IS NOT NULL AND nr_seq_justificativa_w::text <> '') then 
		select	ds_motivo 
		into STRICT	ds_justificativa_item_w 
		from	motivo_justif_req 
		where	nr_sequencia = nr_seq_justificativa_w;
	end if;
 
	ds_comunicacao_w	:= substr(ds_comunicacao_w || rpad(cd_material_w,7) || rpad(substr(OBTER_DESC_MATERIAL(cd_material_w),1,35),36),1,4000);
	ds_comunicacao_w	:= substr(ds_comunicacao_w || rpad(coalesce(OBTER_DESC_MOTIVO_BAIXA_REQ(cd_motivo_baixa_w),' '),20),1,4000);
	ds_comunicacao_w	:= substr(ds_comunicacao_w || ' ' || rpad(coalesce(qt_material_requisitada_w,0),10) || rpad(coalesce(qt_material_atendida_w,0),10) || ds_quebra_linha_w,1,4000);
	if (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') then 
  --Obs: = 502224 
		ds_comunicacao_w	:= substr(ds_comunicacao_w || obter_desc_expressao(502224)||' \i ' || ds_justificativa_w || ' \i0 ' || ds_quebra_linha_w || ds_justificativa_item_w || ' \i0 ' || ds_quebra_linha_w,1,4000);
	end if;
	end;
end loop;
close C01;
 
ds_comunicacao_w	:= substr(ds_comunicacao_w,1,3985) || '\f1\fs20\par}';
 
insert	into comunic_interna( 
			cd_estab_destino, 
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
			dt_liberacao) 
	values (		cd_estabelecimento_w, 
			clock_timestamp(), 
			ds_titulo_w, 
			ds_comunicacao_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			'N', 
			ds_destinatario_w, 
			nr_sequencia_w, 
			'N', 
			nr_seq_classif_w, 
			clock_timestamp());
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comunic_atend_req ( nr_requisicao_material_p bigint, nm_usuario_p text) FROM PUBLIC;
