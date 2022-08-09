-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_guia_medico_selecao ( nr_seq_prestador_p bigint, nr_seq_atendimento_p bigint, nr_seq_plano_p bigint, nr_seq_tipo_guia_medico_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

 
/*	ie_opcao_p 
	I = Inserir w_pls_gua_medico_selecao 
	G = Gerar histórico atendimento */
 
 
ds_historico_w			varchar(4000)	:= null;
nm_prestador_w			varchar(80)	:= null;
ds_endereco_w			varchar(80);
cd_prestador_w			varchar(30);
ds_telefone_w			varchar(20);
count_w				bigint;
qt_tam_historico_w		bigint;
nr_seq_tipo_historico_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tipo_guia_medico_w	bigint;
nr_seq_atendimento_hist_w	bigint;

C01 CURSOR FOR 
	SELECT	substr(pls_obter_dados_prestador(a.nr_seq_prestador, 'N'),1, 80), 
		substr(pls_obter_end_prestador(a.nr_seq_prestador,null, null),1,80),			 
		substr(pls_obter_dados_prestador(a.nr_seq_prestador, 'TC'),1, 20), 
		substr(pls_obter_dados_prestador(a.nr_seq_prestador, 'CD'),1, 30), 
		a.nr_seq_prestador, 
		a.nr_seq_plano, 
		a.nr_seq_tipo_guia_medico 
	from	w_pls_guia_medico_selecao	a 
	where	a.nm_usuario	= nm_usuario_p;


BEGIN 
if (ie_opcao_p = 'I') then 
	select	count(*) 
	into STRICT	count_w 
	from	w_pls_guia_medico_selecao	a 
	where	a.nr_seq_prestador	= nr_seq_prestador_p;
 
	if (count_w = 0) then 
		insert into w_pls_guia_medico_selecao(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_prestador, 
			nr_seq_plano, 
			nr_seq_tipo_guia_medico) 
		values (nextval('w_pls_guia_medico_selecao_seq'), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nr_seq_prestador_p, 
			nr_seq_plano_p, 
			nr_seq_tipo_guia_medico_p);
 
		commit;
	else 
		delete from w_pls_guia_medico_selecao where nr_seq_prestador = nr_seq_prestador_p;
	end if;
elsif (ie_opcao_p = 'G') then 
	select	count(*) 
	into STRICT	count_w 
	from	w_pls_guia_medico_selecao	a 
	where	a.nm_usuario	= nm_usuario_p;
 
	if (count_w <> 0) then 
		ds_historico_w	:= 'Auxílio guia médico, prestadores sugeridos:';
		 
		select	nextval('pls_atendimento_historico_seq') 
		into STRICT	nr_seq_atendimento_hist_w 
		;			
 
		if (pls_obter_se_controle_estab('GA') = 'S') then 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_tipo_historico_w 
			from	pls_tipo_historico_atend 
			where	ie_gerado_sistema	= 'S' 
			and	ie_situacao		= 'A' 
			and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
		else 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_tipo_historico_w 
			from	pls_tipo_historico_atend 
			where	ie_gerado_sistema	= 'S' 
			and	ie_situacao		= 'A';
		end if;
		 
		insert into pls_atendimento_historico(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			dt_historico, 
			ds_historico_long, 
			nr_seq_atendimento, 
			nr_seq_tipo_historico, 
			ie_gerado_sistema) 
		values (nr_seq_atendimento_hist_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			clock_timestamp(), 
			ds_historico_w, 
			nr_seq_atendimento_p, 
			nr_seq_tipo_historico_w, 
			'S');
			 
		open C01;
		loop 
		fetch C01 into	 
			nm_prestador_w, 
			ds_endereco_w, 
			ds_telefone_w, 
			cd_prestador_w, 
			nr_seq_prestador_w, 
			nr_seq_plano_w, 
			nr_seq_tipo_guia_medico_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			select	length(ds_historico_w) 
			into STRICT	qt_tam_historico_w 
			;
			 
			if (qt_tam_historico_w < 4000) then 
				ds_historico_w	:= substr(ds_historico_w || chr(10) || cd_prestador_w || ' - ' || chr(10) || nm_prestador_w || chr(10) || ds_endereco_w || chr(10) || 
										ds_telefone_w || chr(10),1,4000);
			end if;
						 
			insert into pls_atendimento_hist_item(nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				nr_seq_atend_hist, 
				nr_seq_prestador, 
				nr_seq_plano, 
				nr_seq_tipo_guia_medico) 
			values (nextval('pls_atendimento_hist_item_seq'), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nr_seq_atendimento_hist_w, 
				nr_seq_prestador_w, 
				nr_seq_plano_w, 
				nr_seq_tipo_guia_medico_w);			
			end;
		end loop;
		close C01;
		 
		select	length(ds_historico_w) 
		into STRICT	qt_tam_historico_w 
		;
		 
		if (qt_tam_historico_w < 4000) then 
			ds_historico_w	:= substr(ds_historico_w || chr(10) || chr(10) || 'Atendimento - ' || obter_nome_usuario(nm_usuario_p),1,4000);
		end if;
 
		update	pls_atendimento_historico 
		set	ds_historico_long	= ds_historico_w 
		where	nr_sequencia 	= nr_seq_atendimento_hist_w;
 
		delete from w_pls_guia_medico_selecao where nm_usuario = nm_usuario_p;
		 
		commit;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_guia_medico_selecao ( nr_seq_prestador_p bigint, nr_seq_atendimento_p bigint, nr_seq_plano_p bigint, nr_seq_tipo_guia_medico_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
