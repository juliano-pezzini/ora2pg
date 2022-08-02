-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_gerar_atencao_saude ( nr_seq_lote_sip_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
cd_estabelecimento_w		smallint;
qt_nasc_vivos_prematuros_w	integer	:= 0;
qt_nasc_vivos_w			integer	:= 0;
qt_nasc_mortos_w		integer	:= 0;
qt_complicacao_neonatal_w	integer	:= 0;
nr_seq_protocolo_w		bigint;
dt_mes_competencia_w		timestamp;
nr_seq_conta_w			bigint;
dt_autorizacao_w		timestamp;
nr_seq_segurado_w		bigint;
nr_seq_saida_int_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_procedimento_w		timestamp;
cd_cid_principal_w		varchar(10);
qt_idade_w			smallint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_regra_w			bigint;
cd_estrutura_w			varchar(10)	:= '';
ds_regra_w			varchar(255);
ie_expostos_w			varchar(1);
ie_quantidade_w			varchar(1);
qt_idade_min_w			smallint;
qt_idade_max_w			smallint;
ie_regra_w			varchar(1);
qt_eventos_w			bigint	:= 0;
qt_exame_ano_w			integer	:= 0;
qt_expostos_w			bigint	:= 0;
ie_sexo_w			varchar(1);
ie_regime_int_regra_w		varchar(1);
ie_tipo_conta_w			varchar(2);
qt_segurado_w			bigint	:= 0;
qt_proc_estrutura_w		integer	:= 0;
cd_estrutura_sip_w		varchar(20);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_estrutura,
		ds_regra,
		ie_expostos,
		ie_quantidade,
		qt_idade_min,
		qt_idade_max,
		ie_regime_internacao
	from	sip_regra
	order by
		cd_estrutura;

C02 CURSOR FOR
	/* Ambulatorial */

	SELECT	'A',
		a.nr_sequencia nr_seq_protocolo,
		a.dt_mes_competencia,
		b.nr_sequencia nr_seq_conta,
		coalesce(b.dt_atendimento_referencia, b.dt_autorizacao),
		b.nr_seq_segurado,
		coalesce(b.nr_seq_saida_int,0)
	from	pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.ie_status	= 3
	and	a.dt_mes_competencia between dt_periodo_inicial_w and dt_periodo_final_w
	and	a.ie_situacao in ('D','T')
	and	(b.nr_seq_segurado IS NOT NULL AND b.nr_seq_segurado::text <> '')
	and	pls_obter_se_internado(b.nr_sequencia, 'C')	= 'N'
	and	cd_estrutura_w in ('2.1.1', '2.1.2', '2.1.3', '2.2.5.1', '2.2.6.1', '3.1.1', '3.2.5.1', '3.2.6.1',
				'4.1', '4.2', '4.3', '4.4', '4.5', '5.1')
	and	coalesce(b.ie_tipo_segurado,'B')	= 'B'
	and	b.ie_tipo_guia <> '6'
	
union

	/* Internação */

	SELECT	'I',
		a.nr_sequencia nr_seq_protocolo,
		a.dt_mes_competencia,
		b.nr_sequencia nr_seq_conta,
		coalesce(b.dt_atendimento_referencia, b.dt_autorizacao),
		b.nr_seq_segurado,
		coalesce(b.nr_seq_saida_int,0)
	from	pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.ie_status	= 3
	and	a.dt_mes_competencia between dt_periodo_inicial_w and dt_periodo_final_w
	and	a.ie_situacao in ('D','T')
	and	(b.nr_seq_segurado IS NOT NULL AND b.nr_seq_segurado::text <> '')
	and	((coalesce(b.ie_regime_internacao::text, '') = '') or (coalesce(ie_regime_int_regra_w::text, '') = '') or (b.ie_regime_internacao = ie_regime_int_regra_w))
	and	pls_obter_se_internado(b.nr_sequencia, 'C')	= 'S'
	and	cd_estrutura_w in ('1.1.5', '2.2.1', '2.2.2', '2.2.3', '2.2.4', '2.2.5', '2.2.6', '3.2.1', '3.2.2',
				'3.2.2.1', '3.2.3', '3.2.3.1', '3.2.4', '3.2.5', '3.2.6', '5.2')
	and	coalesce(b.ie_tipo_segurado,'B')	= 'B'
	and	b.ie_tipo_guia <> '6';

C03 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		coalesce(dt_procedimento, dt_mes_competencia_w)
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_w;


BEGIN

begin
select	dt_periodo_inicial,
	coalesce(dt_periodo_final, clock_timestamp()),
	cd_estabelecimento
into STRICT	dt_periodo_inicial_w,
	dt_periodo_final_w,
	cd_estabelecimento_w
from	pls_lote_sip
where	nr_sequencia	= nr_seq_lote_sip_p;
exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort('Problema na leitura dos dados do lote SIP (' || nr_seq_lote_sip_p || ')');
end;

CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '1.1', 'Atenção à Criança -Hospital', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '2.1', 'Atenção à Mulher - Ambulatório', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '2.2', 'Atenção à Mulher - Hospital', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '3.1', 'Atenção ao Adulto e ao Idoso - Ambulatório', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '3.2', 'Atenção ao Adulto e ao Idoso - Hospital', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '4.', 'Saúde Bucal', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '5.', 'Saúde Mental', null, null, nm_usuario_p, cd_estabelecimento_w, 'N', 'N');

select	sum(coalesce(qt_nasc_vivos_prematuros_imp,0)),
	sum(coalesce(qt_nasc_vivos_imp,0)),
	sum(coalesce(qt_nasc_mortos_imp,0)),
	sum(CASE WHEN ie_complicacao_neonatal='S' THEN 1  ELSE 0 END )
into STRICT	qt_nasc_vivos_prematuros_w,
	qt_nasc_vivos_w,
	qt_nasc_mortos_w,
	qt_complicacao_neonatal_w
from	pls_conta		b,
	pls_protocolo_conta	a
where	a.nr_sequencia		= b.nr_seq_protocolo
and	a.dt_mes_competencia between dt_periodo_inicial_w and dt_periodo_final_w
and	a.ie_situacao in ('D','T')
and	a.ie_status	= 3
and	coalesce(b.ie_tipo_segurado,'B')	= 'B'
and	b.ie_tipo_guia <> '6';

CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '1.1.1', 'Nascido vivo prematuro', null, qt_nasc_vivos_prematuros_w, nm_usuario_p, cd_estabelecimento_w, 'N', 'S');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '1.1.2', 'Nascido vivo a Termo', null, qt_nasc_vivos_w, nm_usuario_p, cd_estabelecimento_w, 'N', 'S');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '1.1.3', 'Nascido morto', null, qt_nasc_mortos_w, nm_usuario_p, cd_estabelecimento_w, 'N', 'S');
CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, '1.1.4', 'Internação em UTI no período neonatal', null, qt_complicacao_neonatal_w, nm_usuario_p, cd_estabelecimento_w, 'N', 'S');

/*delete from logxxxx_tasy
where	cd_log	= 2011;*/
open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	cd_estrutura_w,
	ds_regra_w,
	ie_expostos_w,
	ie_quantidade_w,
	qt_idade_min_w,
	qt_idade_max_w,
	ie_regime_int_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_eventos_w	:= 0;
	qt_expostos_w	:= 0;
	open C02;
	loop
	fetch C02 into
		ie_tipo_conta_w,
		nr_seq_protocolo_w,
		dt_mes_competencia_w,
		nr_seq_conta_w,
		dt_autorizacao_w,
		nr_seq_segurado_w,
		nr_seq_saida_int_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	coalesce(max(cd_pessoa_fisica),'')
		into STRICT	cd_pessoa_fisica_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;

		begin
		select	coalesce(trunc(dividir((dt_mes_competencia_w - dt_nascimento),365)),999),
			ie_sexo
		into STRICT	qt_idade_w,
			ie_sexo_w
		from	pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		exception
			when others then
			qt_idade_w	:= 999;
		end;

		select	coalesce(max(cd_doenca),'0')
		into STRICT	cd_cid_principal_w
		from	pls_diagnostico_conta
		where	nr_seq_conta	= nr_seq_conta_w;

		if (qt_idade_w >= coalesce(qt_idade_min_w,qt_idade_w)) and (qt_idade_w <= coalesce(qt_idade_max_w,qt_idade_w)) then
			if (nr_seq_regra_w in (1,2,3,4,5,8,11,12,14,15,20,22,23,24,25,26,27)) then
				/* Cursor dos procedimentos */

				open C03;
				loop
				fetch C03 into
					cd_procedimento_w,
					ie_origem_proced_w,
					dt_procedimento_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					/* Verificar se esse é o 1º exame no ano */

					qt_exame_ano_w	:= 0;
					if (nr_seq_regra_w	in (1,2,8,11,12,20,22,23,24,26)) then
						select	count(*)
						into STRICT	qt_exame_ano_w
						from	pls_conta_proc		b,
							pls_conta		a
						where	a.nr_sequencia		= b.nr_seq_conta
						and	a.nr_seq_segurado	= nr_seq_segurado_w
						and	b.cd_procedimento	= cd_procedimento_w
						and	b.ie_origem_proced	= ie_origem_proced_w
						and	b.dt_procedimento	< dt_procedimento_w
						and	coalesce(a.ie_tipo_segurado,'B')	= 'B'
						and	a.ie_tipo_guia <> '6';
					end if;

					if (qt_exame_ano_w	= 0) then
						ie_regra_w := sip_executar_regra(nr_seq_lote_sip_p, nr_seq_regra_w, cd_procedimento_w, ie_origem_proced_w, cd_cid_principal_w, nr_seq_saida_int_w, cd_estabelecimento_w, nm_usuario_p, ie_regra_w);
						if (ie_regra_w	= 'S') then
							qt_eventos_w	:= qt_eventos_w	+ 1;
						end if;
					end if;
					if (cd_procedimento_w	> 0) and (ie_origem_proced_w	> 0) then
						begin
						cd_estrutura_sip_w	:= sip_obter_estrutura_proced(cd_procedimento_w, ie_origem_proced_w, 'C');
						insert into sip_anexo_iv_procedimento(nr_sequencia,
							nr_seq_lote_sip,
							cd_procedimento,
							ie_origem_proced,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_estrutura_sip,
							qt_procedimento)
						values (	nextval('sip_anexo_ii_procedimento_seq'),
							nr_seq_lote_sip_p,
							cd_procedimento_w,
							ie_origem_proced_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_estrutura_sip_w,
							qt_exame_ano_w);
						exception
							when others then
							CALL wheb_mensagem_pck.exibir_mensagem_abort(cd_procedimento_w || ' - ' || ie_origem_proced_w);
						end;
					end if;

					end;
				end loop;
				close C03;
			/* Executar as regras que NÃO dependem do procedimento lançado na conta */

			elsif (nr_seq_regra_w in (6,7,9,10,13,16,17,18,19,21,29,30,31)) then
				/* Verificar se essa é a 1º internação no ano */

				qt_exame_ano_w	:= 0;
				if (nr_seq_regra_w	in (7,10,19,21)) then
					select	count(*)
					into STRICT	qt_exame_ano_w
					from	pls_diagnostico_conta	b,
						pls_conta		a
					where	a.nr_sequencia		= b.nr_seq_conta
					and	a.nr_seq_segurado	= nr_seq_segurado_w
					and	b.cd_doenca		= cd_cid_principal_w
					and	coalesce(a.dt_atendimento_referencia, a.dt_autorizacao) < dt_autorizacao_w
					and	coalesce(a.ie_tipo_segurado,'B')	= 'B'
					and	a.ie_tipo_guia <> '6';
				end if;

				if (qt_exame_ano_w	= 0) then
					ie_regra_w := sip_executar_regra(nr_seq_lote_sip_p, nr_seq_regra_w, 0, 0, cd_cid_principal_w, nr_seq_saida_int_w, cd_estabelecimento_w, nm_usuario_p, ie_regra_w);
					if (ie_regra_w	= 'S') then
						qt_eventos_w	:= qt_eventos_w	+ 1;
					end if;
				end if;
			end if;
		end if;
		end;
	end loop;
	close C02;

	select	count(*)
	into STRICT	qt_proc_estrutura_w
	from	sip_regra_criterio
	where	nr_seq_regra_sip	= nr_seq_regra_w;

	/* Calcular o número de expostos */

	if (qt_proc_estrutura_w > 0) and (ie_expostos_w	= 'S') then
		/* Obter a quantidade de beneficiários que não possuem mais carências */

		select	count(*)
		into STRICT	qt_segurado_w
		from	pessoa_fisica	b,
			pls_segurado	a
		where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((dt_ultima_carencia	< dt_periodo_inicial_w) or (coalesce(dt_ultima_carencia::text, '') = ''))
		and	coalesce(dt_rescisao::text, '') = ''
		and	coalesce(trunc(dividir((dt_periodo_final_w - dt_nascimento),365)),999)
			between qt_idade_min_w and qt_idade_max_w;

		qt_expostos_w	:= qt_segurado_w;
	end if;

	CALL sip_gravar_atencao_saude(nr_seq_lote_sip_p, cd_estrutura_w, ds_regra_w, qt_expostos_w, qt_eventos_w, nm_usuario_p, cd_estabelecimento_w, ie_expostos_w, ie_quantidade_w);
	/*insert into logxxxxx_tasy
		(dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values (sysdate,
		nm_usuario_p,
		2011,
		nr_seq_regra_w || ' - ' || cd_estrutura_w || ' - ' || ds_regra_w || ' - ' || ie_expostos_w || ' - ' || ie_quantidade_w);*/
	commit;
	CALL gravar_processo_longo('Cursor C01','SIP_GERAR_ATENCAO_SAUDE',-1);
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_gerar_atencao_saude ( nr_seq_lote_sip_p bigint, nm_usuario_p text) FROM PUBLIC;

