-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_comunicar_historico ( nr_sequencia_p bigint, ie_comunicar_p text, nm_usuario_p text, ie_transf_anexo_p text, cd_estabelecimento_p text) AS $body$
DECLARE


/* ie_comunicar_p
S: Solicitante
E: Executor
*/
ds_titulo_w			varchar(50);
ds_comunicado_w			varchar(32000);
ds_historico_w			varchar(32000);
ds_dano_breve_w			varchar(255);
ds_dano_w			varchar(4000);
nr_ordem_servico_w		bigint;
nr_sequencia_w			bigint;
nr_seq_classif_w			bigint;
nm_usuario_w			varchar(15);
nm_usuario_destino_w		varchar(2000);
qt_historico_w			bigint;
ds_arquivo_w			varchar(255);
ds_pos_inicio_rtf_w			bigint;
ds_pos_inicio_rtf_java_w		bigint;
ds_caminho_w			varchar(255);
ie_visualiza_hist_setor_w		varchar(01) := 'S';
vard2010_w			boolean;

c01 CURSOR FOR
SELECT	coalesce(nm_usuario_exec,'X')
from	man_ordem_servico_exec
where	nr_seq_ordem = nr_ordem_servico_w

union

select	coalesce(nm_usuario_exec,'X')
from	man_ordem_servico
where	nr_sequencia = nr_ordem_servico_w;

c02 CURSOR FOR
SELECT	ds_arquivo
from	man_ordem_serv_arq
where	ie_anexar_email = 'S'
and	nr_seq_ordem = nr_ordem_servico_w;

c_usuarios_solic CURSOR FOR
SELECT	coalesce(b.nm_usuario,'N') nm_usuario,
	coalesce(substr(obter_se_setor_visualiza_hist(nr_sequencia_p,b.cd_setor_atendimento,'V',b.nm_usuario),1,1),'S') ie_visualiza_hist_setor
from	usuario b,
	man_ordem_servico a
where	a.nr_sequencia	= nr_ordem_servico_w
and	b.cd_pessoa_fisica	= a.cd_pessoa_solicitante
and	b.ie_situacao = 'A';

BEGIN

nm_usuario_destino_w	:= '';
VarD2010_w		:= False;

select	max(obter_valor_param_usuario(299, 183, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p))
into STRICT	ds_caminho_w
;

select	count(*)
into STRICT	qt_historico_w
from	man_ordem_serv_tecnico
where	nr_sequencia		= nr_sequencia_p;

if (qt_historico_w > 0) then
	begin

	select	nr_seq_ordem_serv,
		ds_relat_tecnico
	into STRICT	nr_ordem_servico_w,
		ds_historico_w
	from	man_ordem_serv_tecnico
	where	nr_sequencia		= nr_sequencia_p;

	select	ds_dano_breve,
		ds_dano
	into STRICT	ds_dano_breve_w,
		ds_dano_w
	from	man_ordem_servico
	where	nr_sequencia	= nr_ordem_servico_w;

	ds_dano_breve_w := substr(wheb_mensagem_pck.get_texto(305658) || ': ' || ds_dano_breve_w,1,255);
	ds_dano_w := substr('Dano: ' || ds_dano_w,1,4000);

	/*Pega o cabecalho do RTF*/

	if (position('deflang1046' in ds_historico_w) > 0) then     --Delphi 2010
		begin
		VarD2010_w 		:= True;
		ds_pos_inicio_rtf_w 	:= position('\f0\fs20' in ds_historico_w) +8;

		ds_comunicado_w 	:= substr(ds_historico_w,1,ds_pos_inicio_rtf_w);
		end;
	else
		begin
		ds_pos_inicio_rtf_w 	:= position('lang1046' in ds_historico_w) +8;

		ds_comunicado_w 	:= substr(ds_historico_w,1,ds_pos_inicio_rtf_w) || 'fs20 ';
		end;
	end if;

	ds_pos_inicio_rtf_java_w	:= position('JWord2' in ds_historico_w)+8;

	if (ds_pos_inicio_rtf_w <> 8) then /* RTF */
		begin
		ds_comunicado_w 	:= ds_comunicado_w || chr(13) || chr(10) || ds_dano_breve_w || '\par ' || '\par ' ||
						chr(13) || chr(10) || ds_dano_w || '\par ' || '\par ' ||
						substr(wheb_mensagem_pck.get_texto(305659),1,30) || ': ' || '\par ';

		/*Acrecenta resto do conteudo do RTF*/

		ds_comunicado_w := ds_comunicado_w || '\par ';

		if (VarD2010_w) then     --Delphi 2010
			ds_comunicado_w := ds_comunicado_w || '\f0\fs20';
		end if;

		ds_comunicado_w := ds_comunicado_w || substr(ds_historico_w,ds_pos_inicio_rtf_w,length(ds_historico_w));
		end;
	elsif (ds_pos_inicio_rtf_java_w <> 8) then /* RTF */
		begin
		ds_comunicado_w 	:= substr(substr(ds_historico_w,1,ds_pos_inicio_rtf_java_w), 1, 32000);

		ds_comunicado_w 	:= ds_comunicado_w || chr(13) || chr(10) || ds_dano_breve_w || '\par ' || '\par ' ||
						chr(13) || chr(10) || ds_dano_w || '\par ' || '\par ' ||
						obter_desc_expressao(508099)/*'Último histórico: '*/
 || '\par ';

		/*Acrecenta resto do conteudo do RTF*/

		ds_comunicado_w := substr(ds_comunicado_w || '\par '|| substr(ds_historico_w,ds_pos_inicio_rtf_java_w,length(ds_historico_w)), 1, 32000);

		end;
	elsif (ds_pos_inicio_rtf_w = 8) then
		ds_comunicado_w		:= substr(	ds_dano_breve_w || chr(13) || chr(10) || chr(13) || chr(10) ||
							ds_dano_w || chr(13) || chr(10) || chr(13) || chr(10) ||
							substr(wheb_mensagem_pck.get_texto(305659),1,30) || ': ' || chr(13) || chr(10) || chr(13) || chr(10) || ds_historico_w,1,32000);
	end if;

	ds_titulo_w			:= substr(wheb_mensagem_pck.get_texto(305662,'NR_ORDEM=' || nr_ordem_servico_w),1,255);

	select	obter_classif_comunic('F')
	into STRICT	nr_seq_classif_w
	;

	if (ie_comunicar_p = 'S') then
		for r_c_usuarios_solic in c_usuarios_solic loop
			if (r_c_usuarios_solic.nm_usuario <> 'N') and (r_c_usuarios_solic.ie_visualiza_hist_setor in ('S','V')) then
				nm_usuario_destino_w := nm_usuario_destino_w || r_c_usuarios_solic.nm_usuario || ',';
			end if;
		end loop;
	elsif (ie_comunicar_p = 'E') then
		open c01;
		loop
		fetch c01 into
			nm_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			select	coalesce(max(substr(obter_se_setor_visualiza_hist(nr_sequencia_p,cd_setor_atendimento,'V',nm_usuario),1,1)),'S')
			into STRICT	ie_visualiza_hist_setor_w
			from	usuario
			where	nm_usuario = nm_usuario_w;

			if (nm_usuario_w <> 'X') and (ie_visualiza_hist_setor_w in ('S','V')) then
				nm_usuario_destino_w	:= nm_usuario_destino_w || nm_usuario_w || ',';
			end if;
			end;
		end loop;
		close c01;
	end if;

	if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then
		select	nextval('comunic_interna_seq')
		into STRICT	nr_sequencia_w
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
			dt_liberacao)
		values (	clock_timestamp(),
			ds_titulo_w,
			ds_comunicado_w,
			nm_usuario_p,
			clock_timestamp(),
			'N',
			nm_usuario_destino_w,
			nr_sequencia_w,
			'N',
			nr_seq_classif_w,
			clock_timestamp());

		open C02;
		loop
		fetch C02 into
			ds_arquivo_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			if (ie_transf_anexo_p = 'S') then
				while(position('\' in ds_arquivo_w) > 0) loop
					begin
					ds_arquivo_w := substr(ds_arquivo_w,position('\' in ds_arquivo_w)+1, length(ds_arquivo_w));
					end;
				end loop;
			ds_arquivo_w := ds_caminho_w||ds_arquivo_w;
			end if;

			insert into comunic_interna_arq(
						nr_sequencia,
						nr_seq_comunic,
						dt_atualizacao,
						nm_usuario,
						ds_arquivo)
					values (	nextval('comunic_interna_arq_seq'),
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						ds_arquivo_w);
			end;
		end loop;
		close C02;

		Insert into man_ordem_serv_envio(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			dt_envio,
			ie_tipo_envio,
			ds_destino,
			ds_observacao)
		values (	nextval('man_ordem_serv_envio_seq'),
			nr_ordem_servico_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'I',
			substr(nm_usuario_destino_w,1,255),
			substr(wheb_mensagem_pck.get_texto(305663),1,50));
		commit;
	end if;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_comunicar_historico ( nr_sequencia_p bigint, ie_comunicar_p text, nm_usuario_p text, ie_transf_anexo_p text, cd_estabelecimento_p text) FROM PUBLIC;
