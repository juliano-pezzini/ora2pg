-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_ordem_compra ( nr_ordem_compra_p bigint, cd_motivo_baixa_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE

 
ds_historico_w			varchar(4000);
ds_motivo_w			varchar(255);
cd_motivo_baixa_w		bigint;

/* Variáveis para envio da CI */
 
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
nr_seq_regra_w			bigint;
cd_perfil_ww			varchar(10);
qt_regra_usuario_w		bigint;
ie_ci_lida_w			varchar(1);
nm_usuario_destino_w		varchar(255);
ds_titulo_w			varchar(80);
ds_comunic_w			varchar(4000);
nr_seq_comunic_w		bigint;
nr_seq_classif_w		bigint;

/* Se tiver setor na regra, envia CI para os setores */
 
ds_setor_adicional_w  	varchar(2000) := '';
/* Campos da regra Usuário da Regra */
cd_setor_regra_usuario_w	integer;

c04 CURSOR FOR	 
SELECT	b.nr_sequencia, 
	b.cd_perfil 
from	regra_envio_comunic_compra a, 
	regra_envio_comunic_evento b 
where	a.nr_sequencia = b.nr_seq_regra 
and	a.cd_funcao = 917 
and	b.cd_evento = 51 
and	b.ie_situacao = 'A' 
and	a.cd_estabelecimento = cd_estabelecimento_w 
and	((cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '' AND b.cd_setor_destino = cd_setor_atendimento_w) or 
	((coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(b.cd_setor_destino::text, '') = '')) or (coalesce(b.cd_setor_destino::text, '') = '')) 
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_ordem_compra_p,'OC',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

c05 CURSOR FOR 
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento 
from	regra_envio_comunic_usu a 
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN 
 
/* Select da ordem de compra, para busca das informações da mesma */
 
select	cd_estabelecimento, 
	cd_setor_atendimento 
into STRICT	cd_estabelecimento_w, 
	cd_setor_atendimento_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
select	obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
cd_motivo_baixa_w := cd_motivo_baixa_p;
if (cd_motivo_baixa_p = 0) then 
	cd_motivo_baixa_w := null;
end if;
 
update	ordem_compra 
set	dt_baixa		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp(), 
	nr_seq_motivo_baixa	= cd_motivo_baixa_w 
where	nr_ordem_compra		= nr_ordem_compra_p;
 
if (cd_motivo_baixa_w > 0) then 
	 
	select	ds_motivo 
	into STRICT	ds_motivo_w 
	from	motivo_cancel_sc_oc 
	where	nr_sequencia = cd_motivo_baixa_w;
	 
	if (coalesce(ds_observacao_p::text, '') = '') then 
		ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(297820,'DS_MOTIVO_W=' || ds_motivo_w),1,4000);
	else				 
		ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(297821,'DS_MOTIVO_W=' || ds_motivo_w || ';' || 'DS_OBSERVACAO_P=' || ds_observacao_p),1,4000);
	end if;
else 
	if (coalesce(ds_observacao_p::text, '') = '') then 
		ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(297822),1,4000);
	else 
		ds_historico_w := substr(WHEB_MENSAGEM_PCK.get_texto(297823,'DS_OBSERVACAO_P=' || ds_observacao_p),1,4000);
	end if;
end if;
 
/*Baixa os processos de aprovação que ainda estejam pendentes*/
 
update	processo_aprov_compra 
set	ie_aprov_reprov = 'B' 
where	nr_sequencia in ( 
	SELECT	distinct(nr_seq_aprovacao) 
	from	ordem_compra_item 
	where	nr_ordem_compra = nr_ordem_compra_p) 
and	ie_aprov_reprov = 'P';
 
CALL inserir_historico_ordem_compra( 
	nr_ordem_compra_p, 
	'S', 
	WHEB_MENSAGEM_PCK.get_texto(297505), 
	ds_historico_w, 
	nm_usuario_p);
 
open C04;
loop 
fetch C04 into	 
	nr_seq_regra_w, 
	cd_perfil_ww;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin 
	 
	select	count(*) 
	into STRICT	qt_regra_usuario_w 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b, 
		regra_envio_comunic_usu c 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	b.nr_sequencia = c.nr_seq_evento 
	and	b.nr_sequencia = nr_seq_regra_w;
 
	select	coalesce(ie_ci_lida,'N') 
	into STRICT	ie_ci_lida_w 
	from 	regra_envio_comunic_evento 
	where 	nr_sequencia = nr_seq_regra_w;
 
	if (qt_regra_usuario_w > 0) then 
 
		open C05;
		loop 
		fetch C05 into 
			cd_setor_regra_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin 
			if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then 
				ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
			end if;
			end;
		end loop;
		close C05;
 
		nm_usuario_destino_w	:= '';
		nm_usuario_destino_w	:= obter_usuarios_comunic_compras(nr_ordem_compra_p, null, 51, nr_seq_regra_w, '');
		ds_titulo_w		:= '';
		ds_comunic_w		:= '';
 
		ds_comunic_w	:= substr(replace_macro(obter_dados_regra_com_compra(nr_ordem_compra_p, null, 917, 51, nr_seq_regra_w,'M'), 
						'@motivo',ds_motivo_w),1,2000);
						 
		select	substr(obter_dados_regra_com_compra(nr_ordem_compra_p, null, 917, 51 ,nr_seq_regra_w,'T'),1,2000) ds_titulo 
		into STRICT	ds_titulo_w 
		;
 
		if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then 
 
			select	nextval('comunic_interna_seq') 
			into STRICT	nr_seq_comunic_w 
			;
 
			if (cd_perfil_ww IS NOT NULL AND cd_perfil_ww::text <> '') then 
				cd_perfil_ww := cd_perfil_ww ||',';
			end if;
 
			insert	into comunic_interna( 
				cd_estab_destino,				dt_comunicado,				ds_titulo, 
				ds_comunicado,				nm_usuario,				dt_atualizacao, 
				ie_geral,					nm_usuario_destino,			nr_sequencia, 
				ie_gerencial,				nr_seq_classif,				dt_liberacao, 
				ds_perfil_adicional,				ds_setor_adicional) 
			values (	cd_estabelecimento_w,			clock_timestamp(),					ds_titulo_w, 
				ds_comunic_w,				nm_usuario_p,				clock_timestamp(), 
				'N',					nm_usuario_destino_w,			nr_seq_comunic_w, 
				'N',					nr_seq_classif_w,				clock_timestamp(), 
				cd_perfil_ww,				ds_setor_adicional_w);
 
			/*Para que a comunicação seja gerada como lida ao próprio usuário */
 
			if (ie_ci_lida_w = 'S') then 
				insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
			end if;
		end if;
	end if;	
	end;
end loop;
close C04;
 
/*if (nvl(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if; 21/02/2007 - retirado por Fabio - OS51018*/
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_ordem_compra ( nr_ordem_compra_p bigint, cd_motivo_baixa_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
