-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_avisa_aprov_solic_regra ( nr_solic_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_w				bigint;
ds_email_adicional_w			varchar(2000);
cd_perfil_dispara_w			integer;
nr_seq_aprovacao_w			bigint;
nr_seq_aprov_lista_w			varchar(200);
vl_total_aprov_w				double precision;
vl_total_aprov_ww				varchar(100);
nm_usuario_aprov_w			varchar(15);
ie_aprov_reprov_w				varchar(1);
nm_aprov_lista_w				varchar(2000);
nm_solicitante_w				varchar(255);
ds_centro_custo_w			varchar(255);
ds_assunto_w				varchar(255);
ds_mensagem_w				varchar(4000);
ds_email_pessoa_solic_w			varchar(255);
ds_lista_email_w				varchar(4000);
ie_usuario_w				varchar(1);
ds_email_origem_w				varchar(255);
ds_email_comprador_w			varchar(255);
ds_usuario_comprador_w			comprador.nm_guerra%type;
ds_usuario_origem_w			varchar(255);
ds_aprov_reprov_w			varchar(15);
cd_centro_custo_w			integer;
cd_comprador_w				varchar(10);
cd_estabelecimento_w			integer;
ie_momento_envio_w			varchar(1);
ie_aprov_diferente_regra_w			varchar(1);
ds_email_aprov_w				varchar(255);
ds_forn_sugerido_w			varchar(255);
ds_tipo_servico_w			varchar(255);
dt_solicitacao_compra_w			timestamp;
dt_liberacao_w				timestamp;
ds_observacao_w				varchar(4000);
ds_material_w				varchar(2000);
ds_material_ww				varchar(2000);
local_estoque_w				varchar(255);
ds_email_remetente_w			varchar(255);
ie_envia_w				varchar(1);

c00 CURSOR FOR
SELECT	nr_sequencia,
	replace(ds_email_adicional,',',';'),
	coalesce(ds_email_remetente,'X'),
	cd_perfil_disparar,
	coalesce(ie_momento_envio,'I')
from	regra_envio_email_compra
where	ie_tipo_mensagem = 57
and	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_w;

c01 CURSOR FOR
SELECT	nr_seq_aprovacao
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p
group by	nr_seq_aprovacao;

c02 CURSOR FOR
SELECT	nm_usuario_aprov,
	ie_aprov_reprov
from	processo_aprov_compra
where	nr_sequencia in (select	x.nr_seq_aprovacao
			from	solic_compra_item x
			where	x.nr_solic_compra = nr_solic_compra_p)
group by	nm_usuario_aprov,
	ie_aprov_reprov;

c03 CURSOR FOR
SELECT	cd_material||chr(45)||obter_desc_material(cd_material)
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p;


BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	solic_compra
where	nr_solic_compra = nr_solic_compra_p;

select	coalesce(obter_se_envia_email_regra(nr_solic_compra_p, 'SC', 57, cd_estabelecimento_w),'S')
into STRICT	ie_envia_w
;


if (ie_envia_w = 'S') then

	open C00;
	loop
	fetch C00 into
		nr_seq_regra_w,
		ds_email_adicional_w,
		ds_email_remetente_w,
		cd_perfil_dispara_w,
		ie_momento_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
		begin

		if (nr_seq_regra_w > 0) and
			((coalesce(cd_perfil_dispara_w::text, '') = '') or
			(cd_perfil_dispara_w IS NOT NULL AND cd_perfil_dispara_w::text <> '' AND cd_perfil_dispara_w = obter_perfil_ativo)) then
			begin

			select	substr(obter_nome_pf(cd_pessoa_solicitante),1,255),
				substr(obter_desc_centro_custo(cd_centro_custo),1,255),
				cd_centro_custo,
				cd_comprador_resp,
				obter_nome_pf_pj(cd_pessoa_fisica,cd_fornec_sugerido),
				obter_valor_dominio(4200,ie_tipo_servico),
				dt_solicitacao_compra,
				dt_liberacao,
				ds_observacao,
				SUBSTR(cd_local_estoque||'-'||obter_desc_local_estoque(cd_local_estoque),1,255)
			into STRICT	nm_solicitante_w,
				ds_centro_custo_w,
				cd_centro_custo_w,
				cd_comprador_w,
				ds_forn_sugerido_w,
				ds_tipo_servico_w,
				dt_solicitacao_compra_w,
				dt_liberacao_w,
				ds_observacao_w,
				local_estoque_w
			from	solic_compra
			where	nr_solic_compra = nr_solic_compra_p;

			ds_material_ww := '';

			open C03;
			loop
			fetch C03 into
				ds_material_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				if (length(ds_material_ww) <= 1700) then
					ds_material_ww := substr(ds_material_ww || ds_material_w,1,2000);
				end if;
				end;
			end loop;
			close C03;


			open c01;
			loop
			fetch c01 into
				nr_seq_aprovacao_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin

				nr_seq_aprov_lista_w	:= (nr_seq_aprov_lista_w || to_char(nr_seq_aprovacao_w) || ' ');

				end;
			end loop;
			close c01;

			select	coalesce(sum(b.qt_material * coalesce(b.vl_unit_previsto,0)),0)
			into STRICT	vl_total_aprov_w
			from	solic_compra a,
				solic_compra_item b
			where	a.nr_solic_compra = b.nr_solic_compra
			and	coalesce(b.dt_reprovacao::text, '') = ''
			and	(b.dt_autorizacao IS NOT NULL AND b.dt_autorizacao::text <> '')
			and	a.nr_solic_compra = nr_solic_compra_p;

			vl_total_aprov_ww		:= substr(campo_mascara_virgula_casas(vl_total_aprov_w,2),1,100);

			ds_lista_email_w	:= obter_emails_envio_compra(nr_solic_compra_p,'SC',0,0,nr_seq_regra_w,cd_estabelecimento_w,nm_usuario_p);

			if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then
				ds_lista_email_w	:= ds_lista_email_w || ds_email_adicional_w;
			end if;

			open c02;
			loop
			fetch c02 into
				nm_usuario_aprov_w,
				ie_aprov_reprov_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin

				select	CASE WHEN ie_aprov_reprov_w='A' THEN WHEB_MENSAGEM_PCK.get_texto(306796) WHEN ie_aprov_reprov_w='R' THEN WHEB_MENSAGEM_PCK.get_texto(306798) END
				into STRICT	ds_aprov_reprov_w
				;

				nm_aprov_lista_w		:= substr(nm_aprov_lista_w || substr(obter_pessoa_fisica_usuario(nm_usuario_aprov_w,'N'),1,255) ||
								' (' || ds_aprov_reprov_w || ')' || chr(13),1,1800);

				end;
			end loop;
			close c02;

			select	ds_assunto,
				ds_mensagem_padrao
			into STRICT	ds_assunto_w,
				ds_mensagem_w
			from	regra_envio_email_compra
			where	nr_sequencia = nr_seq_regra_w;

			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@solicitacao',  nr_solic_compra_p), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@solicitante', nm_solicitante_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@cd_centro_custo', cd_centro_custo_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_centro_custo', ds_centro_custo_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_forn_sugerido', ds_forn_sugerido_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_tipo_servico', ds_tipo_servico_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@dt_solicitacao_compra', dt_solicitacao_compra_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_observacao', ds_observacao_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_material', ds_material_w), 1, 255);
			ds_assunto_w := substr(replace_macro(ds_assunto_w, '@local_estoque', local_estoque_w),1,255);

			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@solicitacao',  nr_solic_compra_p), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@solicitante', nm_solicitante_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@cd_centro_custo', cd_centro_custo_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_centro_custo', ds_centro_custo_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@vl_total_aprovacao', vl_total_aprov_ww), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@seq_aprovacao', nr_seq_aprov_lista_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@aprovadores_processo', nm_aprov_lista_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_forn_sugerido', ds_forn_sugerido_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_tipo_servico', ds_tipo_servico_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@dt_solicitacao_compra', dt_solicitacao_compra_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@dt_liberacao', dt_liberacao_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_observacao', ds_observacao_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_material', ds_material_w), 1, 4000);
			ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@local_estoque', local_estoque_w),1,4000);

			select	coalesce(max(ie_usuario),'U')
			into STRICT	ie_usuario_w
			from	regra_envio_email_compra
			where	nr_sequencia = nr_seq_regra_w;

			if (ie_usuario_w = 'U') or
				((coalesce(cd_comprador_w,'0') <> 0) and (ie_usuario_w = 'O')) then --Usuario
				begin

				select	ds_email,
					nm_usuario
				into STRICT	ds_email_origem_w,
					ds_usuario_origem_w
				from	usuario
				where	nm_usuario = nm_usuario_p;

				end;
			elsif (ie_usuario_w = 'C') then --Setor compras
				begin

				select	ds_email
				into STRICT	ds_email_origem_w
				from	parametro_compras
				where	cd_estabelecimento = cd_estabelecimento_w;

				select	coalesce(ds_fantasia,ds_razao_social)
				into STRICT	ds_usuario_origem_w
				from	estabelecimento_v
				where	cd_estabelecimento = cd_estabelecimento_w;

				end;
			elsif (ie_usuario_w = 'O') then --Comprador
				begin

				select	max(ds_email),
					max(nm_guerra)
				into STRICT	ds_email_comprador_w,
					ds_usuario_comprador_w
				from	comprador
				where	cd_pessoa_fisica = cd_comprador_w
				and	cd_estabelecimento = cd_estabelecimento_w;

				ds_email_origem_w := ds_email_comprador_w;
				ds_usuario_origem_w := ds_usuario_comprador_w;

				end;
			end if;

			if (ds_email_remetente_w <> 'X') then
				ds_email_origem_w	:= ds_email_remetente_w;
			end if;

			if (ie_momento_envio_w = 'A') then
				begin

				CALL sup_grava_envio_email(
					'SC',
					'57',
					nr_solic_compra_p,
					null,
					null,
					ds_lista_email_w,
					ds_usuario_origem_w,
					ds_email_origem_w,
					ds_assunto_w,
					ds_mensagem_w,
					cd_estabelecimento_w,
					nm_usuario_p);

				end;
			else
				begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_lista_email_w,ds_usuario_origem_w,'M');
				exception
				when others then
					/*gravar__log__tasy(91301,'Falha ao enviar e-mail compras - Evento: 57 - Seq. Regra: ' || nr_seq_regra_w,nm_usuario_p);*/

					CALL gerar_hist_solic_sem_commit(
							nr_solic_compra_p,
							WHEB_MENSAGEM_PCK.get_texto(306799),
							WHEB_MENSAGEM_PCK.get_texto(306800,'NR_SEQ_REGRA_W=' || nr_seq_regra_w),
							'FGE',
							nm_usuario_p);
				end;
			end if;

			end;
		end if;

		end;
	end loop;
	close C00;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_avisa_aprov_solic_regra ( nr_solic_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

