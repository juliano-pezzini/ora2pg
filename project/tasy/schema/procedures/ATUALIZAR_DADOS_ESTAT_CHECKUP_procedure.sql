-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE colunas AS (nm_coluna_w 		varchar(255));


CREATE OR REPLACE PROCEDURE atualizar_dados_estat_checkup (cd_pessoa_fisica_p text, nr_seq_tipo_dado_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* vetor */
type vetor is table of colunas index by integer;

/* globais */
 
vetor_w			vetor;
ivet			integer;
ind			integer;

 
dt_registro_w		timestamp;
dt_registro_ww		varchar(20);
ds_atributos_w		varchar(2000) := '';
ds_comando_w		varchar(2000);
ds_parametro_w		varchar(3000);
nr_seq_tipo_dado_w	bigint;
ds_tipo_dado_w		varchar(80);
nm_atributo_w		varchar(20);
qt_dado_w		double precision;
nr_atendimento_w	bigint;
ds_unidade_w		varchar(20);
vl_ref_inicial_w	double precision;
vl_ref_final_w		double precision;
nr_seq_apres_w		bigint;
ds_dado_w		varchar(255);
ie_status_result_W	varchar(1);
dt_entrada_w		varchar(10);
nr_sequencia_w		bigint;
ds_cor_w		varchar(15);
ds_cor_celula_w		varchar(2000);
ds_ind_w		varchar(15);
ie_pos_checkup_w	varchar(15);
nr_seq_tipo_dado_novo_w	bigint;
ds_module_w		varchar(2000);
OSUSER_w		varchar(2000);
C04				integer;
ds_data_w		varchar(255);
retorno_w			integer;

c02 CURSOR FOR 
	SELECT	b.nr_seq_tipo_dado, 
		substr(obter_desc_tipo_dado_checkup(b.nr_seq_tipo_dado),1,80), 
		'DIA_' || CASE WHEN b.ie_pos_checkup='S' THEN to_char(b.dt_registro,'ddmmyyyyhh24miss')  ELSE to_char(a.dt_entrada,'ddmmyyyyhh24miss') END , 
		to_char(CASE WHEN b.ie_pos_checkup='S' THEN b.dt_registro  ELSE a.dt_entrada END ,'dd/mm/yy'), 
		coalesce(to_char(b.qt_dado), b.ds_dado), 
		b.nr_atendimento, 
		coalesce(c.ds_unidade,' '), 
		coalesce(obter_ref_checkup(cd_pessoa_fisica_p,c.nr_sequencia,0, 'MIN'),-100), 
		coalesce(obter_ref_checkup(cd_pessoa_fisica_p,c.nr_sequencia,0, 'MAX'),-100), 
		coalesce(b.ie_status_result,'V'), 
		coalesce(b.nr_seq_apres,c.nr_seq_apres), 
		c.ds_cor, 
		b.qt_dado, 
		coalesce(b.ie_pos_checkup,'N') 
	from	checkup_tipo_dado_estat c, 
		checkup_dado_estat b, 
		atendimento_paciente a 
	where	a.nr_atendimento	= b.nr_atendimento 
	and	b.nr_seq_tipo_dado	= c.nr_sequencia 
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	c.ie_situacao		= 'A' 
	and	b.nr_seq_tipo_dado	= nr_seq_tipo_dado_p 
	and	CASE WHEN b.ie_pos_checkup='S' THEN  b.dt_registro  ELSE a.dt_entrada END  = to_date(vetor_w[ind].nm_coluna_w,'dd/mm/yyyy hh24:mi:ss') 
	and	exists (	SELECT	1 
				from	atendimento_paciente c 
				where	c.cd_pessoa_fisica	= cd_pessoa_fisica_p 
				and	c.nr_atendimento	= a.nr_atendimento) 
	order by c.nr_seq_apres;


BEGIN 
 
ivet	:= 0;
/* completar vetor se necessário */
 
ind := ivet;
while(ind < 30) loop 
	begin 
	ind := ind + 1;
	 
	 
	 
	ds_comando_w	:= 	' select	ds_result'||to_char(ind)||	 
				' from		w_dado_checkup	'|| 
				' where		ie_ordem = -3 ' || 
				' and		nm_usuario	= :NM_USUARIO';
	 
	C04 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C04, ds_comando_w, dbms_sql.Native);
	 
	DBMS_SQL.DEFINE_COLUMN(C04,1,ds_data_w,255);
	 
	 
	DBMS_SQL.BIND_VARIABLE(C04,'NM_USUARIO', nm_usuario_p);
	retorno_w := DBMS_SQL.execute(C04);
	 
		while( DBMS_SQL.FETCH_ROWS(C04) > 0 ) loop 
		begin 
		DBMS_SQL.COLUMN_VALUE(C04,1,ds_data_w);
		 
		 
		vetor_w[ind].nm_coluna_w	:= ds_data_w;
		 
		 
		 
		end;
	end loop;
	DBMS_SQL.CLOSE_CURSOR(C04);
	 
	 
	 
	end;
end loop;
 
 
 
ds_comando_w	:=	' update w_dado_checkup '|| 
			' set ds_cor_celula =	null '|| 
			' where nm_usuario = :nm_usuario '|| 
			' and NR_SEQ_TIPO_DADO = :NR_SEQ_TIPO_DADO';
 
ds_parametro_w	:= 'NR_SEQ_TIPO_DADO='||nr_seq_tipo_dado_p ||'#@#@nm_usuario='||nm_usuario_p;
 
CALL exec_sql_dinamico_bv('TASY', ds_comando_w,ds_parametro_w);
 
 
ind := 0;
while(ind < 30) loop 
	begin 
	ind := ind + 1;
	 
	open	c02;
	loop 
	fetch	c02 into 
		nr_seq_tipo_dado_w, 
		ds_tipo_dado_w, 
		nm_atributo_w, 
		dt_entrada_w, 
		ds_dado_w, 
		nr_atendimento_w, 
		ds_unidade_w, 
		vl_ref_inicial_w, 
		vl_ref_final_w, 
		ie_status_result_W, 
		nr_seq_apres_w, 
		ds_cor_w, 
		qt_dado_w, 
		ie_pos_checkup_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		 
		ds_cor_celula_w := '';
		 
		if (ie_status_result_W = 'B') or (ie_status_result_W <> 'N') and (vl_ref_inicial_w <> -100) and (qt_dado_w IS NOT NULL AND qt_dado_w::text <> '') and (qt_dado_w < vl_ref_inicial_w) then 
			begin 
 
			select	CASE WHEN length(to_char(ind))=1 THEN '0'||to_char(ind)  ELSE to_char(ind) END  
			into STRICT	ds_ind_w 
			;
 
			ds_cor_celula_w	:= ds_ind_w ||'790'||',';
			end;
		elsif (ie_status_result_W = 'A') or (ie_status_result_W <> 'N') and (vl_ref_final_w <> -100) and (qt_dado_w IS NOT NULL AND qt_dado_w::text <> '') and (qt_dado_w > vl_ref_final_w) then 
			begin 
			select	CASE WHEN length(to_char(ind))=1 THEN '0'||to_char(ind)  ELSE to_char(ind) END  
			into STRICT	ds_ind_w 
			;
 
			ds_cor_celula_w	:= ds_ind_w ||'791'||',';
			end;
		end if;
 
		ds_comando_w	:=	' update w_dado_checkup '|| 
					' set ds_result' || to_char(ind) || ' = :ds_entrada' || 
					' where nm_usuario = :nm_usuario '|| 
					' and ie_ordem = 0';
 
		ds_parametro_w	:= 'ds_entrada='||dt_entrada_w ||'#@#@nm_usuario='||nm_usuario_p;
 
		CALL exec_sql_dinamico_bv('TASY', ds_comando_w,ds_parametro_w);
 
		ds_comando_w	:=	' update w_dado_checkup '|| 
					' set ds_result' || to_char(ind) || ' = :nr_atendimento' || 
					' where nm_usuario = :nm_usuario '|| 
					' and ie_ordem = 1';
					 
		if (coalesce(ie_pos_checkup_w,'N') = 'S') then 
			ds_parametro_w	:= 'nr_atendimento=P '||nr_atendimento_w ||'#@#@nm_usuario='||nm_usuario_p;
		else 
			ds_parametro_w	:= 'nr_atendimento='||nr_atendimento_w ||'#@#@nm_usuario='||nm_usuario_p;
		end if;
		 
 
		CALL exec_sql_dinamico_bv('TASY', ds_comando_w,ds_parametro_w);
 
		if (substr(ds_dado_w,1,1) = ',') then 
			ds_dado_w	:= '0'||ds_dado_w;
		end if;
/* 
		vl_ref_inicial_w		:= replace(vl_ref_inicial_w,',','.'); 
		vl_ref_final_w		:= replace(vl_ref_final_w,',','.'); 
*/
 
		ds_comando_w	:=	' update w_dado_checkup '|| 
					' set ds_result' || to_char(ind) || ' = :ds_dado' || 
					' ,ds_unidade		= :ds_unidade '|| 
					' ,vl_ref_inicial	= :vl_ref_inicial'|| 
					' ,vl_ref_final		= :vl_ref_final'|| 
					' ,ie_status_result	= :ie_status_result'|| 
					' ,nr_seq_apres		= :nr_seq_apres'|| 
					' ,ds_cor		= :ds_cor'|| 
					' ,ds_cor_celula	= ds_cor_celula || :ds_cor_celula'|| 
					' ,ie_pos_checkup	= :ie_pos_checkup ' || 
					' where nm_usuario	= :nm_usuario '|| 
					' and  nr_seq_tipo_dado = :nr_seq_tipo_dado';
		 
		ds_parametro_w	:= 	'ds_dado='||ds_dado_w ||'#@#@ds_unidade='||ds_unidade_w ||'#@#@vl_ref_inicial='||vl_ref_inicial_w || 
					'#@#@vl_ref_final='||vl_ref_final_w ||'#@#@ie_status_result='||ie_status_result_W ||'#@#@nr_seq_apres='||nr_seq_apres_w|| 
					'#@#@nm_usuario='||nm_usuario_p ||'#@#@ie_pos_checkup='||ie_pos_checkup_w||'#@#@nr_seq_tipo_dado='||nr_seq_tipo_dado_w ||'#@#@ds_cor='||ds_cor_w || 
					'#@#@ds_cor_celula='||ds_cor_celula_w;
 
		CALL exec_sql_dinamico_bv('TASY',ds_comando_w,ds_parametro_w);
 
		end;
	end loop;
	close c02;
	end;
end loop;
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_estat_checkup (cd_pessoa_fisica_p text, nr_seq_tipo_dado_p bigint, nm_usuario_p text) FROM PUBLIC;
