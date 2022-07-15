-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE coi_gerar_w_razao_tit_rec (dt_parametro_p timestamp, nm_usuario_p text, ie_considera_cancel_p text, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
DECLARE

 
dt_inicio_w		timestamp;
dt_final_w		timestamp;
cd_cgc_w		varchar(14);
cd_pessoa_fisica_w	varchar(10);
vl_saldo_ant_w		double precision;
vl_saldo_atual_w	double precision;
ie_tipo_w		integer;
dt_movimento_w		timestamp;
nr_documento_w		varchar(255);
vl_movimento_w		double precision;
vl_credito_w		double precision;
vl_debito_w		double precision;
nr_sequencia_w		bigint;
cd_estabelecimento_w	smallint;

C01 CURSOR FOR 
	SELECT	distinct 
		cd_pessoa_fisica, 
		cd_cgc 
	from	titulo_receber 
	where	coalesce(dt_contabil, dt_emissao)  < dt_final_w 
	and	coalesce(dt_liquidacao,clock_timestamp())	>= dt_inicio_w 
------	and	obter_dados_pf_pj(null,cd_cgc,'TP') = '1' 
	and	cd_estabelecimento		= cd_estabelecimento_w;

C02 CURSOR FOR 
	SELECT	1, 
		b.dt_recebimento, 
		SUBSTR('Baixa Título: ' || c.nr_titulo || ' / ' || c.nr_nota_fiscal,1,255), 
		coalesce(b.vl_recebido,0) vl_movimento 
	from 	titulo_receber_liq b, 
		titulo_receber c 
	where	b.nr_titulo		= c.nr_titulo 
---	and	obter_dados_pf_pj(null,c.cd_cgc,'TP') = '1' 
	and (c.cd_cgc		= cd_cgc_w OR 
		c.cd_pessoa_fisica 	= cd_pessoa_fisica_w) 
	and	b.dt_recebimento	BETWEEN dt_inicio_w AND dt_final_w 
	and (c.cd_estabelecimento	= cd_estabelecimento_w) 
	and	c.ie_origem_titulo = '2' 
  and	coalesce(b.cd_tipo_recebimento,0) <> 4 
	--- Desabilitado para encerramento da conta 900 em 31/03/2009 
	--- and nvl(b.nr_seq_trans_fin,0) <> 2321 
	and	coalesce(c.dt_contabil, c.dt_emissao) 	<= dt_final_w 
	and (  c.ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and c.ie_situacao = '3' and c.ie_tipo_inclusao<>'1') ) 
---	and	((c.ie_situacao not in('5','3') and 'N'	= ie_considera_cancel_p) OR 
---	 	 (c.ie_situacao <> '5' and 'S'		= ie_considera_cancel_p)) 
	
UNION ALL
 
	SELECT	2, 
		b.dt_recebimento, 
		SUBSTR('Baixa Cta.Cancelada: ' || c.nr_titulo || ' / ' || c.nr_nota_fiscal,1,255), 
		coalesce(b.vl_recebido,0) vl_movimento 
	from 	titulo_receber_liq b, 
		titulo_receber c 
	where	b.nr_titulo		= c.nr_titulo 
---	and	obter_dados_pf_pj(null,c.cd_cgc,'TP') = '1' 
	and (c.cd_cgc		= cd_cgc_w OR 
		c.cd_pessoa_fisica 	= cd_pessoa_fisica_w) 
	and	b.dt_recebimento	BETWEEN dt_inicio_w AND dt_final_w 
	and (c.cd_estabelecimento	= cd_estabelecimento_w) 
	and	c.ie_origem_titulo = '2' 
	and	coalesce(b.cd_tipo_recebimento,0) = 4 
	and	coalesce(c.dt_contabil, c.dt_emissao) 	<= dt_final_w 
	and (  c.ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and c.ie_situacao = '3' and c.ie_tipo_inclusao<>'1') ) 
	
union all
 
	select	3, 
		b.dt_recebimento, 
		SUBSTR('Glosa Título: ' || c.nr_titulo || ' / ' || c.nr_nota_fiscal,1,255), 
		coalesce(b.vl_glosa,0) vl_movimento 
	from 	titulo_receber_liq b, 
		titulo_receber c 
	where	b.nr_titulo		= c.nr_titulo 
---	and	obter_dados_pf_pj(null,c.cd_cgc,'TP') = '1' 
	and (c.cd_cgc		= cd_cgc_w OR 
		c.cd_pessoa_fisica 	= cd_pessoa_fisica_w) 
	and	b.dt_recebimento	BETWEEN dt_inicio_w AND dt_final_w 
	and (c.cd_estabelecimento	= cd_estabelecimento_w) 
	and	c.ie_origem_titulo = '2'	-- Conta Paciente 
	--- Desabilitado para encerramento da conta 900 em 31/03/2009 
	--- and	c.ie_tipo_inclusao = '1'	-- Manual 
	and 	coalesce(b.vl_glosa,0) <> 0 
	and	coalesce(c.dt_contabil, c.dt_emissao) 	<= dt_final_w 
	and (  c.ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and c.ie_situacao = '3' and c.ie_tipo_inclusao<>'1') ) 
	
union all
 
	/* -------- Desabilitado para encerramento da conta 900 em 31/03/2009 
	select	4, 
		b.dt_recebimento, 
		SUBSTR('Baixa Dif.Pgto.Conv. Título: ' || c.nr_titulo || ' / ' || c.nr_nota_fiscal,1,255), 
		nvl(b.vl_recebido,0) vl_movimento 
	from 	titulo_receber_liq b, 
		titulo_receber c 
	where	b.nr_titulo		= c.nr_titulo 
----	and	obter_dados_pf_pj(null,c.cd_cgc,'TP') = '1' 
	and	(c.cd_cgc		= cd_cgc_w OR 
		c.cd_pessoa_fisica 	= cd_pessoa_fisica_w) 
	and	b.dt_recebimento	BETWEEN dt_inicio_w AND dt_final_w 
	and	(c.cd_estabelecimento	= cd_estab_p) 
	and	c.ie_origem_titulo = '0'	-- Transitório 
	and	c.ie_tipo_inclusao = '1'	-- Manual 
	and 	nvl(b.vl_glosa,0) = 0 
	and	nvl(c.dt_contabil, c.dt_emissao) <= dt_final_w 
	and	(  c.ie_situacao not in('5','3') 
		or ('S' = ie_considera_cancel_p and c.ie_situacao = '3' and c.ie_tipo_inclusao<>'1') ) 
	union all 
	*/
 ----------------------------------------------------------------------- 
	SELECT	5, 
		b.dt_alteracao, 
		SUBSTR('Alteração p/ Menor: ' || TO_CHAR(b.nr_titulo),1,255), 
		coalesce((vl_alteracao),0) 
	FROM	alteracao_valor b, 
		titulo_receber a 
	WHERE	b.dt_alteracao			BETWEEN dt_inicio_w AND dt_final_w 
---	and	obter_dados_pf_pj(null,a.cd_cgc,'TP') = '1' 
	and	coalesce(a.dt_contabil, a.dt_emissao) 	<= dt_final_w 
--	AND	(vl_anterior - vl_alteracao)	> 0 
	and	b.ie_aumenta_diminui		= 'D' 
	AND	a.nr_titulo			= b.nr_titulo 
	and	a.ie_origem_titulo = '2'	-- Conta Paciente 
	AND	a.cd_estabelecimento		= cd_estabelecimento_w 
	AND (a.cd_cgc 			= cd_cgc_w OR 
		a.cd_pessoa_fisica		= cd_pessoa_fisica_w) 
	and (  a.ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and a.ie_situacao = '3' and a.ie_tipo_inclusao<>'1') ) 
	
union all
 
	SELECT	6, 
		dt_alteracao, 
		SUBSTR('Alteração p/ Maior: ' || TO_CHAR(b.nr_titulo),1,255), 
		coalesce((vl_alteracao),0) 
	FROM	alteracao_valor b, 
		titulo_receber a 
	WHERE	b.dt_alteracao			BETWEEN dt_inicio_w AND dt_final_w 
---	and	obter_dados_pf_pj(null,a.cd_cgc,'TP') = '1' 
	and	coalesce(a.dt_contabil, a.dt_emissao) 	<= dt_final_w 
--	AND	(vl_anterior - vl_alteracao)	< 0 
	and	b.ie_aumenta_diminui		= 'A' 
	AND	a.nr_titulo			= b.nr_titulo 
	AND (a.cd_cgc			= cd_cgc_w OR 
		a.cd_pessoa_fisica		= cd_pessoa_fisica_w) 
	AND	a.cd_estabelecimento		= cd_estabelecimento_w 
	and	a.ie_origem_titulo = '2'	-- Conta Paciente 
	and (  a.ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and a.ie_situacao = '3' and a.ie_tipo_inclusao<>'1') ) 
	
union all
 
	select	7, 
		coalesce(dt_contabil, dt_emissao), 
		SUBSTR('Inclusão de Título: ' || nr_titulo || ' / ' || coalesce(nr_documento,obter_somente_numero(nr_nota_fiscal)),1,255), 
		coalesce(vl_titulo,0) 
	from	titulo_receber 
	where	coalesce(dt_contabil, dt_emissao)	BETWEEN dt_inicio_w AND dt_final_w 
---	and	obter_dados_pf_pj(null,cd_cgc,'TP') = '1' 
	and (cd_cgc				= cd_cgc_w OR 
		cd_pessoa_fisica		= cd_pessoa_fisica_w) 
	and	cd_estabelecimento		= cd_estabelecimento_w 
	and	ie_origem_titulo = '2'		-- Conta Paciente 
	and (  ie_situacao not in ('5','3') 
		or ('S' = ie_considera_cancel_p and ie_situacao = '3' and ie_tipo_inclusao<>'1') );
		
C03 CURSOR FOR 
SELECT	cd_estabelecimento 
from	estabelecimento 
where	((cd_estabelecimento = cd_estab_p) or (coalesce(cd_estab_p::text, '') = ''));


BEGIN 
 
dt_inicio_w	:= coalesce(dt_inicial_p,trunc(dt_parametro_p, 'month'));
dt_final_w	:= fim_dia(coalesce(dt_final_p,trunc(last_day(dt_parametro_p),'dd')));
 
delete from w_razao_tit_rec;
 
open C03;
loop 
fetch C03 into	 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin 
 
	open C01;
	loop 
	fetch C01 into 
		cd_pessoa_fisica_w, 
		cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
		select nextval('w_razao_tit_rec_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		/* obter saldo anterior */
 
		insert into w_razao_tit_rec(nr_sequencia, 
			cd_pessoa_fisica, 
			cd_cgc, 
			ie_tipo, 
			dt_atualizacao, 
			nm_usuario, 
			dt_movimento, 
			nr_documento, 
			vl_debito, 
			vl_credito, 
			cd_estabelecimento) 
		SELECT	nr_sequencia_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w, 
			0, 
			clock_timestamp(), 
			nm_usuario_p, 
			dt_inicio_w, 
			'Saldo Anterior', 
			--- Alterado para encerramento da conta 900 em 31/03/2009 
			--- nvl(sum(hdp_obter_saldo_titulo_receber(nr_titulo,dt_inicio_w - 1/86400)),0), 
			coalesce(sum(obter_saldo_titulo_receber(nr_titulo,dt_inicio_w - 1/86400)),0), 
			0, 
			cd_estabelecimento_w 
		from	titulo_receber 
		where (cd_cgc			= cd_cgc_w or 
			cd_pessoa_fisica	= cd_pessoa_fisica_w) 
		and (cd_estabelecimento	= cd_estabelecimento_w) 
		and	coalesce(dt_contabil, dt_emissao) 	< dt_inicio_w 
	---	and	obter_dados_pf_pj(null,cd_cgc,'TP') = '1' 
		and (  ie_origem_titulo = '2'	 	-- Conta Paciente 
			 or (	 ie_origem_titulo = '0'		-- Transitório 
			   and ie_tipo_inclusao = '1') )	-- Manual 
		and (  ie_situacao not in ('5','3') 
			or ('S' = ie_considera_cancel_p and ie_situacao = '3' and ie_tipo_inclusao<>'1') );
		---and	(  (ie_situacao not in('5','3') and 'N' = ie_considera_cancel_p) 
		---	 or (ie_situacao <> '5' 	 and 'S' = ie_considera_cancel_p) ); 
		 
		open C02;
		loop 
		fetch C02 into 
			ie_tipo_w, 
			dt_movimento_w, 
			nr_documento_w, 
			vl_movimento_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		 
			vl_credito_w := 0;
			vl_debito_w := 0;
			if (ie_tipo_w > 5) then 
				vl_debito_w	:= vl_movimento_w;
			else 
				vl_credito_w	:= vl_movimento_w;
			end if;
			 
			select nextval('w_razao_tit_rec_seq') 
			into STRICT	nr_sequencia_w 
			;
			 
			insert into w_razao_tit_rec(nr_sequencia, 
				cd_pessoa_fisica, 
				cd_cgc, 
				ie_tipo, 
				dt_atualizacao, 
				nm_usuario, 
				dt_movimento, 
				nr_documento, 
				vl_credito, 
				vl_debito, 
				cd_estabelecimento) 
			values (nr_sequencia_w, 
				cd_pessoa_fisica_w, 
				cd_cgc_w, 
				ie_tipo_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				dt_movimento_w, 
				nr_documento_w, 
				vl_credito_w, 
				vl_debito_w, 
				cd_estabelecimento_w);
		end loop;
		close C02;
		 
		select	nextval('w_razao_tit_rec_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		/* obter saldo atual */
 
		insert into w_razao_tit_rec(nr_sequencia, 
			cd_pessoa_fisica, 
			cd_cgc, 
			ie_tipo, 
			dt_atualizacao, 
			nm_usuario, 
			dt_movimento, 
			nr_documento, 
			vl_debito, 
			vl_credito, 
			cd_estabelecimento) 
		SELECT	nr_sequencia_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w, 
			9, 
			clock_timestamp(), 
			nm_usuario_p, 
			dt_final_w, 
			'Saldo Atual', 
			-- Alterado para encerramento da conta 900 em 31/03/2009 
			-- nvl(sum(hdp_obter_saldo_titulo_receber(nr_titulo,dt_final_w)),0), 
			coalesce(sum(obter_saldo_titulo_receber(nr_titulo,dt_final_w)),0), 
			0, 
			cd_estabelecimento_w 
		from 	titulo_receber 
		where (cd_cgc			= cd_cgc_w or 
			cd_pessoa_fisica	= cd_pessoa_fisica_w) 
		and (cd_estabelecimento	= cd_estabelecimento_w) 
		and	coalesce(dt_contabil, dt_emissao) 	<= dt_final_w 
	---	and	obter_dados_pf_pj(null,cd_cgc,'TP') = '1' 
		and (  ie_origem_titulo = '2'	 	-- Conta Paciente 
			 or (	 ie_origem_titulo = '0'		-- Transitório 
			   and ie_tipo_inclusao = '1') )	-- Manual 
		and (  ie_situacao not in ('5','3') 
			or ('S' = ie_considera_cancel_p and ie_situacao = '3' and ie_tipo_inclusao<>'1') );
	end loop;
	close C01;
	 
	end;
end loop;
close C03;
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE coi_gerar_w_razao_tit_rec (dt_parametro_p timestamp, nm_usuario_p text, ie_considera_cancel_p text, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

