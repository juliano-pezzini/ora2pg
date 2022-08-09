-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE migrar_senhas_customizacao (nm_usuario_p text) AS $body$
DECLARE


nm_usuario_w		varchar(15);
nm_usuario_padrao_w	varchar(15);
nm_maquina_w		varchar(40);
cd_perfil_w		bigint;
cd_estabelecimento_w	bigint;

nm_componente_w		varchar(100);
ds_cor_w		varchar(20);
ds_fonte_w		varchar(20);
ie_italico_w		varchar(1);
ie_negrito_w		varchar(1);
ie_riscado_w		varchar(1);
ie_sublinhado_w		varchar(1);
ie_centralizar_w	varchar(1);
ie_quebra_linha_w	varchar(1);
ie_alinhamento_texto_w	varchar(1);
ie_redimensionar_w	varchar(1);
ds_titulo_w		varchar(100);
qt_topo_w		bigint;
qt_esquerda_w		bigint;
qt_altura_w		bigint;
qt_largura_w		bigint;
qt_tamanho_fonte_w	bigint;

nr_sequencia_w		bigint;
nr_seq_comp_monitor_w	bigint;
ie_tipo_componente_w	bigint;
ie_origem_informacao_w	bigint;

--busca customizacao
c01 CURSOR FOR
	SELECT	distinct
		nm_usuario,
		nm_maquina,
		cd_perfil,
		cd_estabelecimento
	from	monitor_senha_custom
	order by
		nm_usuario,
		nm_maquina,
		cd_perfil,
		cd_estabelecimento;

--busca itens da customização
c02 CURSOR FOR
	SELECT	nm_componente,
		qt_topo,
		qt_esquerda,
		qt_altura,
		qt_largura,
		qt_tamanho_fonte,
		ds_cor,
		ds_fonte,
		ie_italico,
		ie_negrito,
		ie_riscado,
		ie_sublinhado,
		ie_centralizar,
		ie_quebra_linha
	FROM	monitor_senha_custom
	WHERE	coalesce(nm_usuario,'X') = coalesce(nm_usuario_w, 'X')
	AND	coalesce(nm_maquina,'X') = coalesce(nm_maquina_w, 'X')
	AND	coalesce(cd_perfil,0) = coalesce(cd_perfil_w, 0)
	AND	coalesce(cd_estabelecimento,0) = coalesce(cd_estabelecimento_w, 0);


BEGIN
	nm_usuario_padrao_w := nm_usuario_p;

	if (coalesce(nm_usuario_padrao_w::text, '') = '') then
		select 	max(nm_usuario)
		into STRICT	nm_usuario_padrao_w
		from	usuario;
	end if;

	select 	max(nm_usuario)
	into STRICT	nm_usuario_padrao_w
	from	usuario
	where 	nm_usuario = nm_usuario_padrao_w;

	if (coalesce(nm_usuario_padrao_w::text, '') = '') then
		select 	max(nm_usuario)
		into STRICT	nm_usuario_padrao_w
		from	usuario;
	end if;

	open c01;
	loop
	fetch c01 into	nm_usuario_w,
			nm_maquina_w,
			cd_perfil_w,
			cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		--Busca nr_sequencia do computador de acordo com nome registrado;
		select	max(nr_sequencia) nr_sequencia
		into STRICT	nr_seq_comp_monitor_w
		from	computador
		where	nm_computador = nm_maquina_w
		and	ie_situacao = 'A';

		select	nextval('customizacao_monitor_seq')
		into STRICT	nr_sequencia_w
		;

		insert into customizacao_monitor(
			nr_sequencia,
			nm_usuario_custom,
 			nr_seq_comp_monitor,
 			cd_perfil,
 			cd_estabelecimento,
 			dt_atualizacao,
 			nm_usuario,
 			dt_atualizacao_nrec,
 			nm_usuario_nrec,
 			ie_situacao)
		values (nr_sequencia_w,
 			nm_usuario_w,
 			nr_seq_comp_monitor_w,
 			cd_perfil_w,
 			cd_estabelecimento_w,
 			clock_timestamp(),
 			nm_usuario_padrao_w,
 			clock_timestamp(),
 			nm_usuario_padrao_w,
 			'A');

		--Busca Itens da Customização
		open c02;
		loop
		fetch c02 into
			nm_componente_w,
			qt_topo_w,
			qt_esquerda_w,
			qt_altura_w,
			qt_largura_w,
			qt_tamanho_fonte_w,
			ds_cor_w,
			ds_fonte_w,
			ie_italico_w,
			ie_negrito_w,
			ie_riscado_w,
			ie_sublinhado_w,
			ie_centralizar_w,
			ie_quebra_linha_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			--TTipoComponente = (tcTexto, tcSenha, tcPaciente, tcGuiche, tcMedico, tcVideo, tcTempoEspera, tcConsulta, tcGrid);
			--TTipoInformacao = (tiInformacaoAtual, tiInformacaoAnterior1, tiInformacaoAnterior2, tiInformacaoAnterior3, tiTextoEstatico, tiTextoRotativo);
			ie_redimensionar_w := 'S';
			ie_alinhamento_texto_w := 'C';
			ds_titulo_w := '';
			if (position('ds_tempo_espera_lb' in nm_componente_w) > 0) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308776); --'Tempo';
				ie_tipo_componente_w := 6;			-- 6 = tcTempoEspera
				ie_origem_informacao_w := 0;			-- 0 = tiInformacaoAtual
			elsif (position('nm_medico_movel_lb' in nm_componente_w) > 0) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308777); --'Médico';
				ie_tipo_componente_w := 4;			-- 4 = tcMedico
				ie_origem_informacao_w := 0;			-- 0 = tiInformacaoAtual
				ie_redimensionar_w := 'N';
				qt_largura_w := qt_largura_w + (qt_esquerda_w * 2);
				qt_esquerda_w := 0;
			elsif	((position('guiche' in nm_componente_w) > 0) or (position('guinhe' in nm_componente_w) > 0)) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308778); --'Guichê Senha';
				ie_tipo_componente_w := 3;			-- 3 = tcGuiche
				ie_redimensionar_w := 'N';
				qt_esquerda_w := qt_esquerda_w - 50;
				qt_largura_w := qt_largura_w + 100;

				if (position('_temp_1_' in nm_componente_w) > 0) then
					ie_origem_informacao_w := 1;		-- 1 = tiInformacaoAnterior1
				elsif (position('_temp_2_' in nm_componente_w) > 0) then
					ie_origem_informacao_w := 2;		-- 2 = tiInformacaoAnterior2
				elsif (position('_temp_3_' in nm_componente_w) > 0) then
					ie_origem_informacao_w := 3;		-- 3 = tiInformacaoAnterior3
				else
					ds_titulo_w := Wheb_mensagem_pck.get_texto(308779); --'Guichê';
					ie_origem_informacao_w := 0;		-- 0 = tiInformacaoAtual
				end if;
			elsif (position('nm_paciente_senha_movel_lb' in nm_componente_w) > 0) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308780); --'Paciente';
				ie_tipo_componente_w := 2;			-- 2 = tcPaciente
				ie_origem_informacao_w := 0;			-- 0 = tiInformacaoAtual
				ie_redimensionar_w := 'N';
				qt_largura_w := qt_largura_w + (qt_esquerda_w * 2);
				qt_esquerda_w := 0;
			elsif (position('senha_movel_lb' in nm_componente_w) > 0) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308781); --'SENHA';
				ie_tipo_componente_w := 0;			-- 0 = tcTexto
				ie_origem_informacao_w := 4;			-- 4 = tiTextoEstatico
			elsif (position('texto_monitor_movel' in nm_componente_w) > 0) then
				ds_titulo_w := Wheb_mensagem_pck.get_texto(308782); --'Texto';
				ie_tipo_componente_w := 0;			-- 0 = tcTexto
				ie_origem_informacao_w := 5;			-- 5 = tiTextoRotativo
			elsif (position('senha' in nm_componente_w) > 0) then
				ie_tipo_componente_w := 1;			-- 1 = tcSenha
				ie_redimensionar_w := 'N';
				qt_esquerda_w := qt_esquerda_w - 50;
				qt_largura_w := qt_largura_w + 100;

				if (position('_temp_1_' in nm_componente_w) > 0) then
					ds_titulo_w := 'S998';
					ie_origem_informacao_w := 1;		-- 1 = tiInformacaoAnterior1
				elsif (position('_temp_2_' in nm_componente_w) > 0) then
					ie_origem_informacao_w := 2;		-- 2 = tiInformacaoAnterior2
					ds_titulo_w := 'S997';
				elsif (position('_temp_3_' in nm_componente_w) > 0) then
					ds_titulo_w := 'S996';
					ie_origem_informacao_w := 3;		-- 3 = tiInformacaoAnterior3
				else
					ds_titulo_w := 'S999';
					ie_origem_informacao_w := 0;		-- 0 = tiInformacaoAtual
				end if;
			end if;

			--gravar itens da customizacao:
			CALL gravar_custom_monitor_item(	nr_sequencia_w,
							ds_titulo_w,
							ie_tipo_componente_w,
							ie_origem_informacao_w,
							qt_topo_w,
							qt_esquerda_w,
							qt_altura_w,
							qt_largura_w,
							ds_fonte_w,
							qt_tamanho_fonte_w,
							ds_cor_w,
							ie_alinhamento_texto_w,
							ie_italico_w,
							ie_negrito_w,
							ie_sublinhado_w,
							ie_riscado_w,
							ie_centralizar_w,
							ie_redimensionar_w,
							ie_quebra_linha_w,
							'clBlack',		--ds_cor_componente_w
							'',			--ds_comando_sql_p
							0,			--nr_seq_objeto_consulta_p
							1,			--ie_controla_exec_video_p
							0,
							nm_usuario_padrao_w);
			end;
		end loop;
		close c02;

		end;
	end loop;
	close c01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE migrar_senhas_customizacao (nm_usuario_p text) FROM PUBLIC;
