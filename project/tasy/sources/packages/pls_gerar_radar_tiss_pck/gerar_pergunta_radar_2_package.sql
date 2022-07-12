-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_radar_tiss_pck.gerar_pergunta_radar_2 () AS $body$
DECLARE

	 
	dt_inicio_radar_w		timestamp;
	dt_fim_radar_w			timestamp;
	nr_seq_prestador_w		bigint;
	cd_cgc_w			varchar(14);
	nr_cpf_w			pessoa_fisica.nr_cpf%type;
	cd_municipio_ibge_w		varchar(10);
	qt_registro_w			bigint;
	nr_seq_pergunta02_w		bigint;
	qt_guias_total_w		bigint;
	qt_guias_eletro_w		bigint;
	qt_itens_eletro_w		bigint;
	qt_itens_total_w		bigint;
	vl_eletro_w			double precision;
	vl_total_w			double precision;
	ds_versao_tiss_w		varchar(255);
	ie_tipo_guia_tasy_w		varchar(255);
	ie_tipo_guia_radar_w		varchar(255);
	nr_ano_w			pls_radar_tiss.nr_ano%type;
	vl_remuneracao_prestador_w	pls_radar_pergunta02.vl_remuneracao_prestador%type;
	vl_remuneracao_operadora_w	pls_radar_pergunta02.vl_remuneracao_operadora%type;
	vl_remuneracao_outros_w		pls_radar_pergunta02.vl_remuneracao_outros%type;
	
	C01 CURSOR FOR 
		SELECT	nr_sequencia, 
			cd_cgc, 
			CASE WHEN cd_pessoa_fisica='' THEN ''  ELSE substr(coalesce(obter_dados_pf(cd_pessoa_fisica, 'CPF'), '00000000000'),1,11) END  
		from	pls_prestador 
		where	trunc(DT_CADASTRO,'Month') <= dt_inicio_radar_w 
		and	((coalesce(DT_EXCLUSAO::text, '') = '') or (trunc(DT_EXCLUSAO,'Month') > dt_fim_radar_w));

	c02 CURSOR FOR 
		SELECT	vl_dominio 
		from	valor_dominio 
		where	cd_dominio	= 5893;

	c03 CURSOR FOR 
		SELECT	count(*), 
			sum(CASE WHEN p.ie_origem_protocolo='E' THEN  1  ELSE 0 END ) qt_guias_eletro, 
			sum(CASE WHEN p.ie_origem_protocolo='E' THEN (SELECT count(*) from pls_conta_proc x where x.nr_seq_conta = c.nr_sequencia) + 					(select count(*) from pls_conta_mat x where x.nr_seq_conta = c.nr_sequencia)  ELSE 0 END ) qt_itens_eletro, 
			sum((select count(*) from pls_conta_proc x where x.nr_seq_conta = c.nr_sequencia) + 
			  (select count(*) from pls_conta_mat x where x.nr_seq_conta = c.nr_sequencia)) qt_itens_total, 
			sum(CASE WHEN p.ie_origem_protocolo='E' THEN  coalesce(CASE WHEN coalesce(c.vl_cobrado,0)=0 THEN c.vl_total  ELSE c.vl_cobrado END ,0)  ELSE 0 END ) vl_eletro, 
			sum(coalesce(CASE WHEN coalesce(c.vl_cobrado,0)=0 THEN c.vl_total  ELSE c.vl_cobrado END ,0)) vl_total, 
			replace(p.cd_versao_tiss,'.','') 
		from	pls_protocolo_conta	p, 
			pls_conta		c, 
			pls_radar_conta 	b 
		where	c.ie_status		not in ('C','S') 
		and	( 
			 (c.ie_tipo_guia = ie_tipo_guia_tasy_w) or 
			 ((coalesce(c.ie_tipo_guia::text, '') = '') and (coalesce(ie_tipo_guia_tasy_w::text, '') = '')) 
			) 
		and	p.nr_seq_prestador	= nr_seq_prestador_w 
		and	c.nr_seq_protocolo	= p.nr_sequencia 
		and	b.nr_seq_conta		= c.nr_sequencia 
		and	b.nr_seq_radar		= get_nr_seq_radar 
		group 	by p.cd_versao_tiss;
		
	C04 CURSOR FOR 
		SELECT	nr_sequencia 
		from	pls_radar_pergunta02 
		where	nr_seq_radar	= get_nr_seq_radar 
		and	coalesce(vl_total,0)	= 0;

	
BEGIN 
	 
	select	trunc(dt_inicio_radar,'dd'), 
		fim_dia(dt_fim_radar), 
		coalesce(nr_ano,2013) 
	into STRICT	dt_inicio_radar_w, 
		dt_fim_radar_w, 
		nr_ano_w 
	from	pls_radar_tiss 
	where	nr_sequencia	= pls_gerar_radar_tiss_pck.get_nr_seq_radar();
	 
	-- Distribuição do quantitativo e valor dos eventos de atenção à Saúde, por prestador de serviços de saúde 
	if (nr_ano_w not in (2014)) then 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_prestador_w, 
			cd_cgc_w, 
			nr_cpf_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			-- Verificar 
			cd_municipio_ibge_w	:= coalesce(replace(substr(pls_obter_dados_prest_end(nr_seq_prestador_w,'',null,'MI'),1,10),'N/D',''), '240220');
 
			open c02;
			loop 
			fetch c02 into 
				ie_tipo_guia_radar_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
 
			 
 
				/* Tipo guia Radar TISS							Tipo Guia Tasy 
 
				1        Guia de consulta				3        Guia de consulta 
				2        Guia de SP/SADT					4        Guia de SP/SADT 
				3        Guia de tratamento odontológico			N/A 
				4        Guia de resumo de internação			5        Guia de Resumo de Internação 
				5        Guia de honorário individual			6        Guia de Honorário Individual 
				6        Guia de outras despesas				7        Guia de Outras Despesas 
				7        Outras guias fora do padrão			NULL 
				*/
 
 
				ie_tipo_guia_tasy_w			:= null;
				if (ie_tipo_guia_radar_w = '1') then 
					ie_tipo_guia_tasy_w		:= '3';
				elsif (ie_tipo_guia_radar_w = '2') then 
					ie_tipo_guia_tasy_w		:= '4';
				elsif (ie_tipo_guia_radar_w = '4') then 
					ie_tipo_guia_tasy_w		:= '5';
				elsif (ie_tipo_guia_radar_w = '5') then 
					ie_tipo_guia_tasy_w		:= '6';
				elsif (ie_tipo_guia_radar_w = '6') then 
					ie_tipo_guia_tasy_w		:= '7';
				end if;
 
				open c03;
				loop 
				fetch c03 into 
					qt_guias_total_w, 
					qt_guias_eletro_w, 
					qt_itens_eletro_w, 
					qt_itens_total_w, 
					vl_eletro_w, 
					vl_total_w, 
					ds_versao_tiss_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
 
					nr_seq_pergunta02_w		:= null;
					if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
						select	max(nr_sequencia) 
						into STRICT	nr_seq_pergunta02_w 
						from	pls_radar_pergunta02 
						where	nr_seq_radar			= get_nr_seq_radar 
						and	cd_ident			= cd_cgc_w 
						--and	nvl(ds_versao_tiss,'X')		= nvl(ds_versao_tiss_w,'X') 
						and	ie_tipo_guia			= ie_tipo_guia_radar_w;
					elsif (nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') then 
						select	max(nr_sequencia) 
						into STRICT	nr_seq_pergunta02_w 
						from	pls_radar_pergunta02 
						where	nr_seq_radar			= get_nr_seq_radar 
						and	cd_ident			= nr_cpf_w 
						--and	nvl(ds_versao_tiss, 'X')	= nvl(ds_versao_tiss_w, 'X') 
						and	ie_tipo_guia			= ie_tipo_guia_radar_w;
					end if;
					 
					if (qt_guias_eletro_w = 0) then 
						ds_versao_tiss_w	:= '';
					else 
						ds_versao_tiss_w	:= coalesce(ds_versao_tiss_w,current_setting('pls_gerar_radar_tiss_pck.cd_versao_tiss_w')::pls_versao_tiss.cd_versao_tiss%type);
					end if;
 
					if (coalesce(nr_seq_pergunta02_w::text, '') = '') then 
						insert into pls_radar_pergunta02(nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							dt_atualizacao_nrec, 
							nm_usuario_nrec, 
							nr_seq_radar, 
							nr_seq_prestador, 
							ie_tipo_ident, 
							cd_ident, 
							cd_municipio_ibge, 
							ie_tipo_guia, 
							qt_guias_eletro, 
							qt_itens_eletro, 
							vl_eletro, 
							qt_guias_total, 
							qt_itens_total, 
							vl_total, 
							ds_versao_tiss) 
						values (nextval('pls_radar_pergunta02_seq'), 
							clock_timestamp(), 
							get_nm_usuario, 
							clock_timestamp(), 
							get_nm_usuario, 
							get_nr_seq_radar, 
							nr_seq_prestador_w, 
							CASE WHEN cd_cgc_w='' THEN '1'  ELSE '2' END , 
							CASE WHEN cd_cgc_w='' THEN nr_cpf_w  ELSE cd_cgc_w END , 
							cd_municipio_ibge_w, 
							ie_tipo_guia_radar_w, 
							qt_guias_eletro_w, 
							qt_itens_eletro_w, 
							vl_eletro_w, 
							qt_guias_total_w, 
							qt_itens_total_w, 
							vl_total_w, 
							ds_versao_tiss_w);
						 
					else 
						update	pls_radar_pergunta02 
						set	qt_guias_eletro		= qt_guias_eletro + qt_guias_eletro_w, 
							qt_itens_eletro		= qt_itens_eletro + qt_itens_eletro_w, 
							vl_eletro		= vl_eletro + vl_eletro_w, 
							qt_guias_total		= qt_guias_total + qt_guias_total_w, 
							qt_itens_total		= qt_itens_total + qt_itens_total_w, 
							ds_versao_tiss		= ds_versao_tiss_w, 
							vl_total		= coalesce(vl_total,0) + coalesce(vl_total_w,0) 
						where	nr_sequencia		= nr_seq_pergunta02_w;
					end if;
 
					commit;
 
				end loop;
				close c03;
			end loop;
			close c02;
		end loop;
		close C01;
		 
		/*Deleta os prestadores que tem valores com 0*/
 
		open c04;
		loop 
		fetch c04 into	 
			nr_seq_pergunta02_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin 
			 
			delete	FROM pls_radar_pergunta02 
			where	nr_sequencia		= nr_seq_pergunta02_w;
			 
			end;
		end loop;
		close c04;
 
	-- Valor total dos eventos de atenção por modelo de remuneração 
	else 
		insert	into pls_radar_pergunta02(nr_sequencia, dt_atualizacao, nm_usuario, 
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_radar, 
			nr_seq_prestador, ie_tipo_ident, cd_ident, 
			cd_municipio_ibge, ie_tipo_guia, qt_guias_eletro, 
			qt_itens_eletro, vl_eletro, qt_guias_total, 
			qt_itens_total, vl_total, ds_versao_tiss, 
			vl_remuneracao_prestador, vl_remuneracao_operadora, vl_remuneracao_outros) 
		values (nextval('pls_radar_pergunta02_seq'), clock_timestamp(), get_nm_usuario, 
			clock_timestamp(), get_nm_usuario, get_nr_seq_radar, 
			null, null, null, 
			null, null, null, 
			null, null, null, 
			null, null, null, 
			0, 0, 0) 
			returning nr_sequencia into nr_seq_pergunta02_w;
	 
		select	sum(coalesce(CASE WHEN coalesce(c.vl_cobrado,0)=0 THEN c.vl_total  ELSE c.vl_cobrado END ,0)) vl_total 
		into STRICT	vl_remuneracao_prestador_w 
		from	pls_protocolo_conta	p, 
			pls_conta		c, 
			pls_radar_conta 	b 
		where	c.ie_status		not in ('C','S') 
		and	c.nr_seq_protocolo	= p.nr_sequencia 
		and	b.nr_seq_conta		= c.nr_sequencia 
		and	b.nr_seq_radar		= get_nr_seq_radar 
		and	p.ie_tipo_protocolo	in ('C')	-- Contas médicas 
		and	not exists (SELECT	1 
					from	pls_prestador	x 
					where	x.nr_sequencia		= c.nr_seq_prestador_exec 
					and	x.ie_tipo_relacao	 not in ('C','D','I','P'));
 
		select	sum(coalesce(CASE WHEN coalesce(c.vl_cobrado,0)=0 THEN c.vl_total  ELSE c.vl_cobrado END ,0)) vl_total 
		into STRICT	vl_remuneracao_operadora_w 
		from	pls_protocolo_conta	p, 
			pls_conta		c, 
			pls_radar_conta 	b 
		where	c.ie_status		not in ('C','S') 
		and	c.nr_seq_protocolo	= p.nr_sequencia 
		and	b.nr_seq_conta		= c.nr_sequencia 
		and	b.nr_seq_radar		= get_nr_seq_radar 
		and	p.ie_tipo_protocolo	in ('I','F')	-- Intercâmbio - Intercâmbio A700 
		and	not exists (SELECT	1 
					from	pls_prestador	x 
					where	x.nr_sequencia		= c.nr_seq_prestador_exec 
					and	x.ie_tipo_relacao	 not in ('C','D','I','P'));
 
		select	sum(coalesce(CASE WHEN coalesce(c.vl_cobrado,0)=0 THEN c.vl_total  ELSE c.vl_cobrado END ,0)) vl_total 
		into STRICT	vl_remuneracao_outros_w 
		from	pls_protocolo_conta	p, 
			pls_conta		c, 
			pls_radar_conta 	b 
		where	c.ie_status		not in ('C','S') 
		and	c.nr_seq_protocolo	= p.nr_sequencia 
		and	b.nr_seq_conta		= c.nr_sequencia 
		and	b.nr_seq_radar		= get_nr_seq_radar 
		and (p.ie_tipo_protocolo	in ('R')	-- Reembolso 
		or	exists (SELECT	1 
				from	pls_prestador	x 
				where	x.nr_sequencia		= c.nr_seq_prestador_exec 
				and	x.ie_tipo_relacao	 not in ('C','D','I','P')));
		 
		update	pls_radar_pergunta02 
		set	vl_remuneracao_prestador	= coalesce(vl_remuneracao_prestador_w,0), 
			vl_remuneracao_operadora	= coalesce(vl_remuneracao_operadora_w,0), 
			vl_remuneracao_outros		= coalesce(vl_remuneracao_outros_w,0) 
		where	nr_sequencia			= nr_seq_pergunta02_w;
	end if;
	 
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_radar_tiss_pck.gerar_pergunta_radar_2 () FROM PUBLIC;