-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_flex_ii_panorama ( cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/*
Opção
E		Escala e índices
Q		Esaclas de queda
*/
				
ds_retorno_w					varchar(4000)	:= '';
nr_seq_setor_w					pan_configuracao_setor.nr_sequencia%Type;	
nm_tabela_w						pep_informacao.nm_tabela%Type;
ds_func_escala_suep_w			pep_informacao.ds_func_escala_suep%Type;
nm_atributo_data_w				pep_informacao.nm_atributo_data%Type;		
nm_atributo_inf_w				pep_informacao.nm_atributo_inf%Type;

nr_seq_escala_w					pan_configuracao_escala.nr_seq_escala%Type;			
ds_score_flex_w					varchar(255);
ds_escala_w						varchar(255);

ds_comando_w					varchar(4000);
qt_reg_w						bigint;
nr_item_pront_w					bigint;
nr_sequencia_w					bigint;
ds_escala2_w					varchar(255);

dt_referencia_w					timestamp;
vl_informacao_w					double precision;
vl_informacao_func_w			varchar(10);
retorno_w						integer;
retorno_escala_w		integer;

C04				integer;
C05				integer;
C21				integer;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pan_configuracao_setor
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and		coalesce(ie_situacao,'A')= 'A'
	order by nr_sequencia;
	
C02 CURSOR FOR
	SELECT	b.nm_tabela,
			b.ds_func_escala_suep,
			b.nm_atributo_data,
			b.nm_atributo_inf,
			a.nr_seq_escala,
			substr(obter_desc_regra_score_flex_II(nr_seq_score_flex,nr_seq_escala),1,255) ds_score_flex,
			substr(coalesce(obter_caption_escala(c.ie_escala),obter_valor_dominio(1799,c.ie_escala)),1,255) ds_escala
	from	pan_configuracao_escala a,
			pep_informacao b,
			escala_documentacao c
	where	a.nr_seq_setor = nr_seq_setor_w
	and		a.nr_seq_escala 	= b.nr_sequencia
	and		b.ie_escala 	= c.ie_escala
	and		a.ie_queda = 'N'
	order by a.nr_sequencia;	
	
			

BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '' AND nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	open C01;
	loop
	fetch C01 into	
		nr_seq_setor_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if ( ie_opcao_p = 'E' ) then
		
			nr_item_pront_w := 2;
		
			open C02;
			loop
			fetch C02 into	
				nm_tabela_w	,
				ds_func_escala_suep_w,
				nm_atributo_data_w,
				nm_atributo_inf_w,
				nr_seq_escala_w,			
				ds_score_flex_w,					
				ds_escala_w;						
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				
				
				ds_comando_w	:= 			'select	    max(nr_sequencia) nr_sequencia '||
											'from		'|| nm_tabela_w	||' '||
											'where		1 = 1 '||
											'and		'|| nm_atributo_inf_w || ' is not null';
											
											
				select	count(*)
				into STRICT	qt_reg_w
				from	tabela_atributo
				where	nm_tabela	= nm_tabela_w
				and		nm_atributo = 'DT_LIBERACAO';

				if ( qt_reg_w	> 0) then
					ds_comando_w := ds_comando_w ||' and dt_liberacao is not null ';
				end if;

				select	count(*)
				into STRICT	qt_reg_w
				from	tabela_atributo
				where	nm_tabela	= nm_tabela_w
				and		nm_atributo = 'DT_INATIVACAO';


				if (qt_reg_w	> 0) then
					ds_comando_w := ds_comando_w ||' and DT_INATIVACAO is null ';
				end if;	


				ds_comando_w := ds_comando_w ||' and nr_atendimento = :nr_atendimento ';
				
				
				ds_comando_w := ds_comando_w ||'and	obter_se_reg_lib_atencao(obter_pessoa_atendimento(nr_atendimento,''C''), null, ie_nivel_atencao, nm_usuario,' ||nr_item_pront_w||') = ''S''';

		
				
				C04 := DBMS_SQL.OPEN_CURSOR;
				DBMS_SQL.PARSE(C04, ds_comando_w, dbms_sql.Native);
				
				
				DBMS_SQL.DEFINE_COLUMN(C04,1,nr_sequencia_w);
				DBMS_SQL.BIND_VARIABLE(C04,'NR_ATENDIMENTO', NR_ATENDIMENTO_P);

				retorno_w := DBMS_SQL.execute(C04);
				
				while( DBMS_SQL.FETCH_ROWS(C04) > 0 ) loop
					begin
					DBMS_SQL.COLUMN_VALUE(C04,1,nr_sequencia_w);
					end;
				end loop;				
				DBMS_SQL.CLOSE_CURSOR(C04);
				
				if ( coalesce(nr_sequencia_w,0) > 0) then
				

					ds_comando_w	:= 			'select	    '|| nm_atributo_data_w ||' dt_referencia ,'||
												'           '|| nm_atributo_inf_w ||' ds_informacao '||
												'from		'|| nm_tabela_w	||' '||
												'where		1 = 1 '||
												'and		nr_sequencia = '|| nr_sequencia_w;
												
					
												
							
					C05 := DBMS_SQL.OPEN_CURSOR;
					DBMS_SQL.PARSE(C05, ds_comando_w, dbms_sql.Native);
					
					DBMS_SQL.DEFINE_COLUMN(C05,1,dt_referencia_w);
					DBMS_SQL.DEFINE_COLUMN(C05,2,vl_informacao_w);

					retorno_w := DBMS_SQL.execute(C05);
					
					while( DBMS_SQL.FETCH_ROWS(C05) > 0 ) loop
						begin
						DBMS_SQL.COLUMN_VALUE(C05,1,dt_referencia_w);
						DBMS_SQL.COLUMN_VALUE(C05,2,vl_informacao_w);
						end;
					end loop;				
					DBMS_SQL.CLOSE_CURSOR(C05);
						
					select	replace(vl_informacao_w,',','.')
					into STRICT	vl_informacao_func_w
					;
					
					if (nr_seq_escala_w = 346 )	then
						select	qt_pontos
						into STRICT	vl_informacao_w
						from 	escala_eif
						where 	nr_sequencia = vl_informacao_w;				
					elsif (nr_seq_escala_w = 347)	then
						select	qt_pontos
						into STRICT	vl_informacao_w
						from 	escala_eif_ii
						where 	nr_sequencia = vl_informacao_w;	
					end if;
				
					if (ds_func_escala_suep_w IS NOT NULL AND ds_func_escala_suep_w::text <> '') then
						
						ds_comando_w 	:= 	'select	     	substr('|| ds_func_escala_suep_w ||'('||vl_informacao_func_w||'),1,255) ds_escala ' ||
											'from		dual';	
						
						C21 := DBMS_SQL.OPEN_CURSOR;
						DBMS_SQL.PARSE(C21, ds_comando_w, dbms_sql.Native);
						DBMS_SQL.DEFINE_COLUMN(C21,1,ds_escala2_w,200);				
						retorno_escala_w := DBMS_SQL.execute(C21);
						
						
						while( DBMS_SQL.FETCH_ROWS(C21) > 0 ) loop
							begin
							DBMS_SQL.COLUMN_VALUE(C21,1,ds_escala2_w );
							end;
						end loop;	
						DBMS_SQL.CLOSE_CURSOR(C21);	
						
						if (ds_score_flex_w IS NOT NULL AND ds_score_flex_w::text <> '') then
						
							ds_retorno_w := substr(ds_retorno_w || ds_score_flex_w ||': '|| ds_escala2_w || ' - '|| dt_referencia_w || ' <br> ',1,4000 );			
						
						end if;
					
					end if;
					
				end if;
				
				end;
			end loop;
			close C02;
		
		end if;
		
		end;
	end loop;
	close C01;



end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_flex_ii_panorama ( cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

