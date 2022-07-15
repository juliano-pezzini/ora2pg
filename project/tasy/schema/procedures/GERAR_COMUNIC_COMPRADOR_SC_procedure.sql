-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comunic_comprador_sc ( nr_solic_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
cd_estabelecimento_w		smallint;
ds_comunicacao_w		varchar(2000);
ds_titulo_w			varchar(80);
ds_destinatario_w		varchar(255);
nr_seq_classif_w		bigint;
nr_sequencia_w			bigint;
qt_regra_usuario_w		bigint;
nr_seq_regra_w			bigint;
cd_setor_atendimento_w		integer;
ie_urgente_w			varchar(1);
cd_evento_w			smallint;
cd_perfil_w			varchar(10);
/* Se tiver setor na regra, envia CI para os setores */
ds_setor_adicional_w		varchar(2000) := '';
/* Campos da regra Usuário da Regra */
cd_setor_regra_usuario_w	integer;

c05 CURSOR FOR 
SELECT	b.nr_sequencia, 
	b.cd_evento, 
	b.cd_perfil 
from	regra_envio_comunic_evento b, 
	regra_envio_comunic_compra a 
where	a.nr_sequencia = b.nr_seq_regra 
and	a.cd_estabelecimento = cd_estabelecimento_w 
and	b.cd_evento = 72 
and	b.ie_situacao = 'A' 
and	((cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '' AND b.cd_setor_destino = cd_setor_atendimento_w) or 
	((coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(b.cd_setor_destino::text, '') = '')) or (coalesce(b.cd_setor_destino::text, '') = '')) 
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_solic_compra_p,'SC',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

c06 CURSOR FOR 
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento 
from	regra_envio_comunic_usu a 
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN 
 
select	cd_setor_atendimento, 
	cd_estabelecimento, 
	ie_urgente 
into STRICT	cd_setor_atendimento_w,	 
	cd_estabelecimento_w,	 
	ie_urgente_w 
from 	solic_compra 
where 	nr_solic_compra = nr_solic_compra_p;
 
open C05;
loop 
fetch C05 into	 
	nr_seq_regra_w, 
	cd_evento_w, 
	cd_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin 
 
	select	count(*) 
	into STRICT	qt_regra_usuario_w 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b, 
		regra_envio_comunic_usu c 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	b.nr_sequencia = c.nr_seq_evento 
	and	b.nr_sequencia = nr_seq_regra_w;
 
	if (nr_seq_regra_w > 0) then 
 
		open C06;
		loop 
		fetch C06 into	 
			cd_setor_regra_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin 
			if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then 
				ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
			end if;
			end;
		end loop;
		close C06;
 
		ds_destinatario_w := obter_usuarios_comunic_compras(nr_solic_compra_p,null,cd_evento_w,nr_seq_regra_w,'');
 
		select	substr(max(obter_dados_regra_com_compra(nr_solic_compra, null, 913, cd_evento_w, nr_seq_regra_w, 'M')),1,2000) ds_comunicacao, 
			substr(max(obter_dados_regra_com_compra(nr_solic_compra, null, 913, cd_evento_w, nr_seq_regra_w,'T')),1,80) ds_titulo 
		into STRICT	ds_comunicacao_w, 
			ds_titulo_w 
		from	solic_compra 
		where	nr_solic_compra = nr_solic_compra_p;
 
		select	obter_classif_comunic('F') 
		into STRICT	nr_seq_classif_w 
		;
 
		select	nextval('comunic_interna_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
			cd_perfil_w := cd_perfil_w ||',';
		end if;
 
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
			dt_liberacao, 
			ds_perfil_adicional, 
			ds_setor_adicional) 
		values (	cd_estabelecimento_w, 
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
			clock_timestamp(), 
			cd_perfil_w, 
			ds_setor_adicional_w);
	end if;
	end;
end loop;
close C05;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comunic_comprador_sc ( nr_solic_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

