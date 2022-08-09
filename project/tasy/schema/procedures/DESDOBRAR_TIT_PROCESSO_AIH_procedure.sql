-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_tit_processo_aih ( nr_seq_protocolo_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
cd_estab_financeiro_w		bigint;
ds_erro_w			varchar(255);
qt_titulo_desdobrar_w		bigint;
nr_titulo_desdobrar_w		bigint;
vl_saldo_titulo_w			double precision;
vl_total_processo_w		double precision;
nr_processo_w			bigint;
qt_processo_w			bigint;
ds_titulos_gerados_w		varchar(80);
vl_processo_w			double precision;

nr_seq_titulo_w			bigint;
conta_titulo_w			smallint := 0;
vl_desdob_w			double precision;
vl_titulo_p1_w			double precision;
vl_titulo_parcela_w			double precision;
cd_estabelecimento_w		smallint;
dt_emissao_w			timestamp;
dt_vencimento_w			timestamp;
dt_pagamento_previsto_w		timestamp;
vl_titulo_w			double precision;
vl_saldo_multa_w			double precision;
tx_juros_w			double precision;
tx_multa_w			double precision;
cd_moeda_w			integer;
cd_portador_w			bigint;
cd_tipo_portador_w			integer;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
tx_desc_antecipacao_w		double precision;
ie_situacao_w			varchar(0001);
ie_tipo_emissao_titulo_w		integer;
ie_origem_titulo_w			varchar(10);
ie_tipo_titulo_w			varchar(5);
ie_tipo_inclusao_w			varchar(0001);
cd_pessoa_fisica_w		varchar(0010);
cd_cgc_w			varchar(0014);
nr_interno_conta_w			bigint;
cd_serie_w			varchar(0005);
nr_documento_w			numeric(22);
nr_sequencia_doc_w		integer;
cd_banco_w			integer;
cd_agencia_bancaria_w		varchar(0008);
nr_bloqueto_w			varchar(0020);
dt_liquidacao_w			timestamp;
nr_lote_contabil_w			bigint;
ds_observacao_titulo_w		varchar(255);
vl_total_titulo_w			double precision := 0;
nr_desdobramentos_w		integer := 0;
nr_guia_w			varchar(20);
dt_desdobramento_w		timestamp;
dt_contabil_w			timestamp;
vl_desdobramento_w		double precision := 0;
nr_seq_desdob_w			bigint := 0;
nr_seq_classe_w			bigint := 0;
nr_seq_protocolo_w		bigint := 0;
nr_atendimento_w			bigint := 0;
ds_titulos_desdob_w		varchar(4000) := '';
vl_rejeitado_proc_w			double precision;
vl_total_processo_w		double precision;
nr_processo_ant_w			bigint;

c01 CURSOR FOR 
SELECT	nr_processo,sum(vl_processo) 
from ( 
	SELECT a.nr_processo, 
		 sum(a.vl_sh + a.vl_sp + a.vl_sadt + a.vl_sangue + a.vl_opm + 
		 a.vl_rnato + a.vl_s_rateio + a.vl_analg + a.vl_pedcon) vl_processo 
	from	 sus_aih_paga a 
	where	 a.nr_seq_protocolo = nr_seq_protocolo_p 
	group by a.nr_processo 
	
union
 
	select a.nr_processo, 
		 sum(c.vl_conta) vl_processo 
	from 	 conta_paciente c, 
		 sus_aih b, 
		 sus_aih_processo d, 
		 sus_aih_rejeitada a 
	where	 a.nr_seq_protocolo		= nr_seq_protocolo_p 
	and   	 a.nr_processo 		= d.nr_processo 
	and   	 d.ie_classificacao 		<> 2 
	and	 a.nr_aih			= b.nr_aih 
	and	 a.nr_seq_aih		= b.nr_sequencia 
	and	 b.nr_interno_conta	= c.nr_interno_conta 
	and	not exists (	select 1 from sus_aih_paga x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_aih			= a.nr_aih 
			and	x.nr_seq_aih		= a.nr_seq_aih) 
	group by a.nr_processo) alias4 
group by nr_processo;

 

BEGIN 
 
ds_erro_w 		:= 'X';
qt_processo_w	:= 0;
 
select count(*) 
into STRICT	qt_titulo_desdobrar_w 
from	titulo_receber 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
if	qt_titulo_desdobrar_w = 0 then 
	ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280484);	
end if;
 
if	qt_titulo_desdobrar_w > 1 then 
	ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280486);	
end if;
 
if (ds_erro_w = 'X') then 
	begin 
	select nr_titulo, 
		vl_titulo, 
		vl_saldo_titulo, 
		dt_liquidacao 
	into STRICT	nr_titulo_desdobrar_w, 
		vl_titulo_w, 
		vl_saldo_titulo_w, 
		dt_liquidacao_w 
	from	titulo_receber 
	where	nr_seq_protocolo = nr_seq_protocolo_p;	
	exception 
		when others then 
		--r.aise_application_error(-20011,'Erro ao ler titulo a ser desdobrado'); 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(267368);
 
	if (vl_titulo_w <> vl_saldo_titulo_w) then 
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280488);	
	end if;
 
	if (vl_titulo_w = 0 or vl_saldo_titulo_w = 0) then 
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280489);	
	end if;
 
	if	(dt_liquidacao_w IS NOT NULL AND dt_liquidacao_w::text <> '') then 
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280491);	
	end if;
 
	end;
end if;
 
if (ds_erro_w = 'X') then 
	begin 
	/* obter valores do titulo a desdobrar */
 
	select cd_estabelecimento, 
		dt_emissao, 
		vl_titulo, 
		vl_saldo_titulo, 
		cd_moeda, 
		cd_portador, 
		cd_tipo_portador, 
		cd_tipo_taxa_juro, 
		cd_tipo_taxa_multa, 
		tx_desc_antecipacao, 
		tx_juros, 
		tx_multa, 
		ie_situacao, 
		ie_tipo_emissao_titulo, 
		ie_origem_titulo, 
		ie_tipo_titulo, 
		ie_tipo_inclusao, 
		cd_pessoa_fisica, 
		cd_cgc, 
		nr_interno_conta, 
		cd_serie, 
		nr_documento, 
		nr_sequencia_doc, 
		cd_banco, 
		cd_agencia_bancaria, 
		nr_bloqueto, 
		dt_liquidacao, 
		nr_lote_contabil, 
		ds_observacao_titulo, 
		dt_contabil, 
		nr_guia, 
		nr_seq_classe, 
		nr_seq_protocolo, 
		nr_atendimento, 
		dt_vencimento 
	into STRICT	cd_estabelecimento_w, 
		dt_emissao_w, 
		vl_titulo_w, 
		vl_saldo_multa_w, 
		cd_moeda_w, 
		cd_portador_w, 
		cd_tipo_portador_w, 
		cd_tipo_taxa_juro_w, 
		cd_tipo_taxa_multa_w, 
		tx_desc_antecipacao_w, 
		tx_juros_w, 
		tx_multa_w, 
		ie_situacao_w, 
		ie_tipo_emissao_titulo_w, 
		ie_origem_titulo_w, 
		ie_tipo_titulo_w, 
		ie_tipo_inclusao_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		nr_interno_conta_w, 
		cd_serie_w, 
		nr_documento_w, 
		nr_sequencia_doc_w, 
		cd_banco_w, 
		cd_agencia_bancaria_w, 
		nr_bloqueto_w, 
		dt_liquidacao_w, 
		nr_lote_contabil_w, 
		ds_observacao_titulo_w, 
		dt_contabil_w, 
		nr_guia_w, 
		nr_seq_classe_w, 
		nr_seq_protocolo_w, 
		nr_atendimento_w, 
		dt_vencimento_w 
	from	titulo_receber 
	where (nr_titulo = nr_titulo_desdobrar_w);
	end;
end if;
 
if (ds_erro_w = 'X') then 
	begin 
 
	select	coalesce(cd_estab_financeiro, cd_estabelecimento) 
	into STRICT	cd_estab_financeiro_w 
	from	estabelecimento 
	where	cd_estabelecimento	= cd_estabelecimento_w;
 
	ds_observacao_titulo_w	:= WHEB_MENSAGEM_PCK.get_texto(280495);
	open c01;
	loop 
	fetch c01 into	 
		nr_processo_w, 
		vl_processo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if (vl_processo_w > 0) then 
			begin 
			qt_processo_w	:= qt_processo_w + 1;
 
			select nextval('titulo_seq') 
			into STRICT nr_seq_titulo_w 
			;
 
			ds_titulos_gerados_w :=(ds_titulos_gerados_w||to_char(nr_seq_titulo_w)||' ');
 
			nr_sequencia_doc_w 	:= nr_sequencia_doc_w + 1;
			ds_observacao_titulo_w	:= substr(ds_observacao_titulo_w ||to_char(nr_processo_w)||' ',1,255);
			begin	 
			insert into titulo_receber(nr_titulo, cd_estabelecimento, dt_atualizacao, nm_usuario, dt_emissao, 
				dt_vencimento,	dt_pagamento_previsto, vl_titulo, 
				vl_saldo_titulo, vl_saldo_juros, vl_saldo_multa, 
				cd_moeda, cd_portador, cd_tipo_portador, tx_juros, tx_multa, 
				cd_tipo_taxa_juro,cd_tipo_taxa_multa, tx_desc_antecipacao, ie_situacao, 
				ie_tipo_emissao_titulo, ie_origem_titulo, 
				ie_tipo_titulo, ie_tipo_inclusao, cd_pessoa_fisica, 
				nr_interno_conta, cd_cgc, cd_serie, 
				nr_documento, nr_sequencia_doc, cd_banco, 
				cd_agencia_bancaria, nr_bloqueto, dt_liquidacao, 
				nr_lote_contabil, ds_observacao_titulo, dt_contabil, 
				nr_guia, nr_seq_classe, nr_seq_protocolo, 
				nr_atendimento,nr_processo_aih, cd_estab_financeiro, nm_usuario_orig, dt_inclusao) 
			values (nr_seq_titulo_w, cd_estabelecimento_w, clock_timestamp(), nm_usuario_p, dt_emissao_w, 
				dt_vencimento_w,dt_vencimento_w, vl_processo_w, 
				vl_processo_w,0,0, 
				cd_moeda_w, cd_portador_w, cd_tipo_portador_w, tx_juros_w, tx_multa_w, 
				cd_tipo_taxa_juro_w,cd_tipo_taxa_multa_w, tx_desc_antecipacao_w, ie_situacao_w, 
				ie_tipo_emissao_titulo_w, ie_origem_titulo_w, 
				ie_tipo_titulo_w, ie_tipo_inclusao_w, cd_pessoa_fisica_w, 
				nr_interno_conta_w, cd_cgc_w, cd_serie_w, 
				nr_documento_w, nr_sequencia_doc_w, cd_banco_w, 
				cd_agencia_bancaria_w, nr_bloqueto_w, dt_liquidacao_w, 
				nr_lote_contabil_w,(WHEB_MENSAGEM_PCK.get_texto(280495) ||to_char(nr_processo_w)), dt_contabil_w, 
				nr_guia_w, nr_seq_classe_w, nr_seq_protocolo_w, 
				nr_atendimento_w,nr_processo_w, cd_estab_financeiro_w, nm_usuario_p, clock_timestamp());
			exception 
				when others then 
				--r.aise_application_error(-20011,'Erro ao gravar titulo receber desdobrado'); 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(267370);
			end;
			end;
		end if;
		end;
	end loop;
	close c01;
	end;
end if;
 
if (ds_erro_w 		= 'X') 	and (qt_processo_w	> 0)		then	 
	begin 
	update titulo_receber 
  	set	 ie_situacao 		= '5', 
		 dt_liquidacao		= clock_timestamp(), 
		 vl_saldo_titulo		= 0, 
		 ds_observacao_titulo	= substr(ds_observacao_titulo_w || chr(13) || WHEB_MENSAGEM_PCK.get_texto(280496) || 
				 		substr(ds_titulos_gerados_w,1,length(ds_titulos_gerados_w)),1,255) 
	where nr_titulo = nr_titulo_desdobrar_w;
	end;
end if;
 
commit;
 
if (ds_erro_w = 'X') then 
	ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(280497);
end if;
 
ds_erro_p	 := ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_tit_processo_aih ( nr_seq_protocolo_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
