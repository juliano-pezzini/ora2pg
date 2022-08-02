-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_grava_inf_fracionameno (cd_barras_integ_p text, hr_inicio_producao_p text, hr_fim_producao_p text, dt_producao_p timestamp, nr_seq_status_integ_p bigint, cd_programa_p bigint, cd_operador_ini_prod_p text, vl_peso_hemo1_p bigint, vl_peso_hemo2_p bigint, vl_peso_hemo3_p bigint, vl_peso_hemo4_p bigint, vl_peso_hemo5_p bigint, vl_peso_hemo6_p bigint, vl_peso_hemo7_p bigint, vl_peso_hemo8_p bigint, vl_peso_hemo9_p bigint, vl_peso_hemo10_p bigint, nr_pausa_integracao_p bigint, qt_min_pausa_integ_p bigint, cd_operador_fim_prod_p text, nr_seq_centrif_integ_p text, nm_programa_p text, hr_total_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_doacao_w			bigint;
nr_seq_insert_hemo_w		bigint;
nr_seq_derivado_w		bigint;
nr_seq_status_integ_w		bigint;
nr_seq_centrif_integ_w		bigint;
ie_existe_doacao_w		varchar(1);
nm_usuario_ini_prod_w		varchar(15);
nm_usuario_fim_prod_w		varchar(15);
nr_seq_lote_bolsa_w		varchar(20);
nr_sangue_w			varchar(20);
ie_erro_w			varchar(1);
nr_seq_derivado_padrao_w	bigint;
ie_tipo_bolsa_w			varchar(10);
qt_total_bolsa_w		bigint;
qt_bolsa_vazia_w		double precision;
cd_barras_integracao_w		san_producao.cd_barras_integracao%type;
qt_bolsas_w			bigint;
ie_existe_barras_w		varchar(1);
ie_sair_w			varchar(1);
ie_verificador_w		varchar(1);
ie_producao_reprod_w		varchar(1);
cd_barras_doacao_w		varchar(20);
nr_seq_prod_origem_w		bigint := null;
nr_seq_antic_w			bigint;
ds_valor_param_331_w		varchar(255);
nr_seq_conservante_w		san_marca_bolsa.nr_seq_conservante%type;

C01 CURSOR FOR 
	SELECT	row_number() OVER () AS rownum, 
		x.nr_seq_derivado 
	from (SELECT	a.nr_seq_derivado, 
			a.ie_ordem 
		from	san_regra_frac_item a, 
			san_regra_integracao_frac x 
		where	a.nr_seq_regra_frac	= x.nr_sequencia 
		and	a.ie_situacao		= 'A' 
		and	x.ie_situacao		= 'A' 
		and	x.cd_externo		= cd_programa_p 
		and	coalesce(x.ie_tipo_bolsa,ie_tipo_bolsa_w)	= ie_tipo_bolsa_w 
		and	coalesce(x.nr_seq_antic,nr_seq_antic_w) 	= nr_seq_antic_w 
		order by	a.ie_ordem) x;
	

BEGIN 
ie_erro_w := 'N';
ie_existe_doacao_w := 'N';
	 
if (cd_barras_integ_p IS NOT NULL AND cd_barras_integ_p::text <> '') then 
	begin 
	 
		ds_valor_param_331_w := obter_valor_param_usuario(450, 331, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
		 
		if (ds_valor_param_331_w = 'B') then 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_doacao_w 
			from	san_doacao 
			where	obter_isbt_doador(nr_sequencia, NULL,'I') = cd_barras_integ_p;
		else 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_doacao_w 
			from	san_doacao 
			where	cd_barras_integracao = cd_barras_integ_p;
		end if;
		 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_existe_doacao_w 
		from	san_doacao 
		where	nr_sequencia = nr_seq_doacao_w;
		 
		select	max(x.nr_sequencia) 
		into STRICT	nr_seq_centrif_integ_w 
		from	san_centrifuga x 
		where	x.cd_centrifuga = nr_seq_centrif_integ_p;
		 
		if (ie_existe_doacao_w = 'N') then 
			ie_erro_w := 'S';
			CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(793550,'NR_SEQ_DOACAO='||nr_seq_doacao_w), nm_usuario_p);
		end if;
	 
	exception 
		when others then 
		ie_erro_w := 'S';
		CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(793553), nm_usuario_p);		
	end;
	 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_prod_origem_w 
	from	san_producao 
	where	nr_seq_doacao = nr_seq_doacao_w 
	and	ie_em_reproducao = 'S';
 
	if (nr_seq_prod_origem_w IS NOT NULL AND nr_seq_prod_origem_w::text <> '') then 
		ie_producao_reprod_w := 'R';
	else 
		ie_producao_reprod_w := 'P';
	end if;
	 
	select	max(x.nr_lote_bolsa), 
		max(x.nr_sangue), 
		max(x.cd_barras_integracao), 
		max(x.nr_seq_derivado_padrao), 
		coalesce(max(x.ie_tipo_bolsa),''), 
		coalesce(max(x.nr_seq_antic),0) 
	into STRICT	nr_seq_lote_bolsa_w, 
		nr_sangue_w, 
		cd_barras_doacao_w, 
		nr_seq_derivado_padrao_w, 
		ie_tipo_bolsa_w, 
		nr_seq_antic_w 
	from	san_doacao x 
	where	x.nr_sequencia = nr_seq_doacao_w;
	 
	select	max(nm_usuario) 
	into STRICT	nm_usuario_ini_prod_w 
	from	usuario x 
	where	x.cd_barras = cd_operador_ini_prod_p;
 
	select	max(x.nm_usuario) 
	into STRICT	nm_usuario_fim_prod_w 
	from	usuario x 
	where	x.cd_barras = cd_operador_fim_prod_p;
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_status_integ_w 
	from	san_integracao_status_frac 
	where	cd_status = nr_seq_status_integ_p;
	 
	if (ie_producao_reprod_w <> 'R') then 
		begin 
			delete	from san_producao 
			where	nr_seq_doacao			= nr_seq_doacao_w 
			and	coalesce(ie_hemocomp_integracao,'N')	= 'N';
		exception 
			when others then 
			ie_erro_w := 'S';
			CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(793554)||' '||chr(13)||sqlerrm, nm_usuario_p);
		end;
	end if;
	 
	begin 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_insert_hemo_w, 
		nr_seq_derivado_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin	 
		 
			ie_sair_w := 'N';
			 
			select	count(*) 
			into STRICT	qt_bolsas_w 
			from	san_producao 
			where	nr_seq_doacao = nr_seq_doacao_w;
			 
			while(ie_sair_w = 'N') loop 
				begin 
				 
				qt_bolsas_w 		:= qt_bolsas_w + 1;
				cd_barras_integracao_w 	:= cd_barras_doacao_w || to_char(lpad(qt_bolsas_w,2,0));
				 
				select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
				into STRICT	ie_existe_barras_w 
				from	san_producao 
				where	cd_barras_integracao = cd_barras_integracao_w;
				 
				if (ie_existe_barras_w = 'N') then 
					ie_sair_w := 'S';
				end if;
				 
				end;
			end loop;		
			 
			select 	max(QT_PESO_BOLSA_VAZIA) 	 
			into STRICT	qt_bolsa_vazia_w 
			from 	SAN_DERIVADO_REGRA 
			where 	nr_seq_derivado = nr_seq_derivado_w 
			and 	ie_situacao = 'A';
				 
			SELECT	san_calc_volume_hemo(nr_seq_derivado_w,(CASE WHEN nr_seq_insert_hemo_w=1 THEN vl_peso_hemo1_p WHEN nr_seq_insert_hemo_w=2 THEN vl_peso_hemo2_p WHEN nr_seq_insert_hemo_w=3 THEN vl_peso_hemo3_p WHEN nr_seq_insert_hemo_w=4 THEN vl_peso_hemo4_p WHEN nr_seq_insert_hemo_w=5 THEN vl_peso_hemo5_p WHEN nr_seq_insert_hemo_w=6 THEN vl_peso_hemo6_p WHEN nr_seq_insert_hemo_w=7 THEN vl_peso_hemo7_p WHEN nr_seq_insert_hemo_w=8 THEN vl_peso_hemo8_p WHEN nr_seq_insert_hemo_w=9 THEN vl_peso_hemo9_p WHEN nr_seq_insert_hemo_w=10 THEN vl_peso_hemo10_p END ),round(qt_bolsa_vazia_w),0,0,ie_tipo_bolsa_w) 
			into STRICT	qt_total_bolsa_w	 
			;
			 
			select	max(b.nr_seq_conservante) 
			into STRICT	nr_seq_conservante_w 
			from	san_doacao a, 
				san_marca_bolsa b, 
				san_derivado_regra c 
			where	a.nr_marca_bolsa 	= b.nr_sequencia 
			and (coalesce(b.ie_tipo_bolsa::text, '') = '' 
				or	c.ie_tipo_bolsa	= a.ie_tipo_bolsa) 
			and	c.nr_seq_conservante 	= b.nr_seq_conservante 
			and (coalesce(c.ie_tipo_bolsa::text, '') = '' 
				or	c.ie_tipo_bolsa = a.ie_tipo_bolsa) 
			and	c.nr_seq_derivado 	= nr_seq_derivado_w 
			and	a.nr_sequencia 		= nr_seq_doacao_w 
			and	c.ie_situacao 		= 'A';
 
 
			if (qt_total_bolsa_w < 0) then 
				qt_total_bolsa_w := 0;
			end if;
		 
			insert into san_producao( 
				nr_sequencia, 
				nr_seq_doacao, 
				nr_seq_derivado, 
				dt_producao, 
				cd_pf_realizou, 
				dt_atualizacao, 
				nm_usuario, 
				dt_vencimento, 
				nr_sangue, 
				ie_irradiado, 
				ie_lavado, 
				ie_filtrado, 
				ie_aliquotado, 
				dt_inicio_producao, 
				dt_fim_producao, 
				nr_seq_status_integracao, 
				nm_usuario_ini_producao, 
				nr_pausa_integracao, 
				qt_min_pausa_integracao, 
				qt_peso_bolsa, 
				qt_peso_bolsa_vazia, 
				qt_volume, 
				nm_usuario_fim_producao, 
				nr_seq_centrifuga, 
				ie_hemocomp_integracao, 
				cd_barras_integracao, 
				nr_seq_prod_origem, 
				cd_estabelecimento, 
				ie_aferese, 
				nr_seq_conservante 
			) values ( 
				nextval('san_producao_seq'), 
				nr_seq_doacao_w, 
				nr_seq_derivado_w, 
				to_date(to_char(dt_producao_p,'dd/mm/yyyy')||to_char(clock_timestamp(),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'), 
				substr(obter_pf_usuario(nm_usuario_p,'C'),1,10), 
				clock_timestamp(), 
				nm_usuario_p, 
				san_obt_dt_vencimento_hemocomp(null,nr_seq_derivado_w,dt_producao_p), 
				nr_sangue_w, 
				'N', 
				'N', 
				'N', 
				'N', 
				to_date(to_char(dt_producao_p,'dd/mm/yyyy')||' '||hr_inicio_producao_p,'dd/mm/yyyy hh24:mi:ss'), 
				null, 
				nr_seq_status_integ_w, 
				nm_usuario_ini_prod_w, 
				nr_pausa_integracao_p, 
				qt_min_pausa_integ_p, 
				(CASE WHEN nr_seq_insert_hemo_w=1 THEN vl_peso_hemo1_p WHEN nr_seq_insert_hemo_w=2 THEN vl_peso_hemo2_p WHEN nr_seq_insert_hemo_w=3 THEN vl_peso_hemo3_p WHEN nr_seq_insert_hemo_w=4 THEN vl_peso_hemo4_p WHEN nr_seq_insert_hemo_w=5 THEN vl_peso_hemo5_p WHEN nr_seq_insert_hemo_w=6 THEN vl_peso_hemo6_p WHEN nr_seq_insert_hemo_w=7 THEN vl_peso_hemo7_p WHEN nr_seq_insert_hemo_w=8 THEN vl_peso_hemo8_p WHEN nr_seq_insert_hemo_w=9 THEN vl_peso_hemo9_p WHEN nr_seq_insert_hemo_w=10 THEN vl_peso_hemo10_p END ), 
				qt_bolsa_vazia_w, 
				qt_total_bolsa_w, 
				null, 
				nr_seq_centrif_integ_w, 
				'S', 
				cd_barras_integracao_w, 
				nr_seq_prod_origem_w, 
				cd_estabelecimento_p, 
				CASE WHEN san_Obter_tipo_coleta(nr_seq_doacao_w)=1 THEN  'S' WHEN san_Obter_tipo_coleta(nr_seq_doacao_w)=3 THEN  'S' WHEN san_Obter_tipo_coleta(nr_seq_doacao_w)=4 THEN  'S'  ELSE 'N' END , 
				nr_seq_conservante_w 
			);
		exception 
			when others then 
			ie_erro_w := 'S';
			CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(793555)||' '|| 
			chr(13)||sqlerrm, nm_usuario_p);
		end;
	end loop;
	close C01;
	 
	exception 
		when others then 
		ie_erro_w := 'S';
		CALL gravar_log_tasy(-98766, wheb_mensagem_pck.get_texto(793556)||'  '||'    '||wheb_mensagem_pck.get_texto(793557)||chr(13)|| 
					'    '||wheb_mensagem_pck.get_texto(793558)||' '||cd_programa_p, nm_usuario_p);					
	end;
 
	if (ie_erro_w = 'N') and (ie_existe_doacao_w = 'S') then 
		 
		update san_doacao 
		set	nr_centrifuga	= nr_seq_centrif_integ_p, 
			cd_result_cod  = to_char(nr_seq_status_integ_p) ,   
			nr_programa   = to_char(cd_programa_p)	 , 
			nm_programa   = nm_programa_p   		 , 
			hr_total    = hr_total_p    
		where	nr_sequencia = nr_seq_doacao_w;
		 
		if (ie_producao_reprod_w = 'R') then 
			update	san_producao 
			set	ie_pai_reproduzido 	= 'S', 
				ie_em_reproducao	= 'N', 
				dt_fim_producao		= clock_timestamp(), 
				nm_usuario_fim_producao	= nm_usuario_p 
			where	nr_sequencia = nr_seq_prod_origem_w;
		end if;
 
	end if;	
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_grava_inf_fracionameno (cd_barras_integ_p text, hr_inicio_producao_p text, hr_fim_producao_p text, dt_producao_p timestamp, nr_seq_status_integ_p bigint, cd_programa_p bigint, cd_operador_ini_prod_p text, vl_peso_hemo1_p bigint, vl_peso_hemo2_p bigint, vl_peso_hemo3_p bigint, vl_peso_hemo4_p bigint, vl_peso_hemo5_p bigint, vl_peso_hemo6_p bigint, vl_peso_hemo7_p bigint, vl_peso_hemo8_p bigint, vl_peso_hemo9_p bigint, vl_peso_hemo10_p bigint, nr_pausa_integracao_p bigint, qt_min_pausa_integ_p bigint, cd_operador_fim_prod_p text, nr_seq_centrif_integ_p text, nm_programa_p text, hr_total_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

