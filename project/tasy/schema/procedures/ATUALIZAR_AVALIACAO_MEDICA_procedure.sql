-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_avaliacao_medica ( nm_tabela_p text, nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, qt_resultado_p text, ds_resultado_p text, nm_usuario_p text, qt_retorno_p INOUT bigint, nm_atributo_p text default null) AS $body$
DECLARE


ds_comando_w			varchar(4000) := '';
nm_atributo_avaliacao_w 		varchar(0040) := '';
ie_resultado_w			varchar(0002) := '';
ds_complemento_w			varchar(4000) := '';
nr_seq_item_refer_w		bigint;
qt_resultado_refer_w		double precision;
qt_resultado_w			varchar(100) := '';
ds_sep_bv_w			varchar(50);

c01 CURSOR FOR
	SELECT	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		med_avaliacao_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	a.nr_seq_avaliacao	= nr_seq_avaliacao_p
	and	upper(nm_tabela_p)	= 'MED_AVALIACAO_RESULT'
	
union

	SELECT	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		sac_pesquisa_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'SAC_PESQUISA_RESULT'
	and	a.nr_seq_pesquisa	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		man_pesquisa_rh_resp a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'MAN_PESQUISA_RH_RESP'
	and	a.nr_seq_pesquisa	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		pls_declaracao_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'PLS_DECLARACAO_RESULT'
	and	a.nr_seq_avaliacao	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		man_ordem_serv_aval_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'MAN_ORDEM_SERV_AVAL_RESULT'
	and	a.nr_seq_ordem_serv_aval = nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		qua_evento_pac_aval_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'QUA_EVENTO_PAC_AVAL_RESULT'
	and	a.nr_seq_evento_aval	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		setor_res_item_aval_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'SETOR_RES_ITEM_AVAL_RESULT'
	and	a.nr_seq_avaliacao	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		qua_doc_tr_pf_aval_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'QUA_DOC_TR_PF_AVAL_RESULT'
	and	a.nr_seq_trein_pf_aval	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		documento_farma_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	upper(nm_tabela_p)	= 'DOCUMENTO_FARMA_RESULT'
	and	a.nr_seq_doc_farm	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		bsc_ind_aval_result a
	where	a.nr_seq_item	= b.nr_sequencia
	and	upper(nm_tabela_p)	= 'BSC_IND_AVAL_RESULT'
	and	a.nr_seq_bsc_ind_aval	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		tre_pesquisa_result a
	where	a.nr_seq_item	= b.nr_sequencia
	and	upper(nm_tabela_p)	= 'TRE_PESQUISA_RESULT'
	and	a.nr_seq_pesquisa	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		com_solic_sd_result a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'COM_SOLIC_SD_RESULT'
	and	a.nr_seq_solic	= nr_seq_avaliacao_p
	
union

	select	a.nr_seq_item,
		a.qt_resultado
	from	med_item_avaliar b,
		reg_avaliacao_cust_resul a
	where	a.nr_seq_item		= b.nr_sequencia
	and	b.ie_resultado		= 'V'
	and	upper(nm_tabela_p)	= 'REG_AVALIACAO_CUST_RESUL'
	and	a.nr_seq_avaliacao	= nr_seq_avaliacao_p
	
union

	select 	a.nr_seq_item,
		a.qt_resultado
	from 	med_item_avaliar b,
		proj_projeto_aval_result a
	where 	a.nr_seq_item 		= b.nr_sequencia
	and 	b.ie_resultado 		= 'V'
	and 	upper(nm_tabela_p) 	= 'PROJ_PROJETO_AVAL_RESULT'
	and 	a.nr_seq_proj_aval 		= nr_seq_avaliacao_p;
	


BEGIN
ds_sep_bv_w	:= obter_separador_bv;

if (coalesce(nm_atributo_p::text, '') = '') then
	select	nm_atributo
	into STRICT	nm_atributo_avaliacao_w
	from	tabela_atributo
	where 	nm_tabela = nm_tabela_p
	and		nr_sequencia_criacao =
			(SELECT min(x.nr_sequencia_criacao)
			from tabela_atributo x
			where x.nm_tabela = nm_tabela_p);
else
	nm_atributo_avaliacao_w := nm_atributo_p;
end	if;			


select	ie_resultado,
	ds_complemento
into STRICT	ie_resultado_w,
	ds_complemento_w
from	med_item_avaliar
where	nr_sequencia	= nr_seq_item_p;

/* Alteração solicitada pelo Coelho...
O mesmo informou que precisa passar os parâmetros numéricos com vírgula e não com ponto...

Rotina abaixo foi alterada...
qt_resultado_w	:= replace(qt_resultado_p,',','.'); */
qt_resultado_w	:= qt_resultado_p;

ds_comando_w	:= 	'delete from ' || nm_tabela_p ||
			' where ' || nm_atributo_avaliacao_w || ' = :nr_seq_avaliacao_p ' ||
			' and	nr_seq_item = :nr_seq_item_p ';

CALL Exec_sql_Dinamico_BV('AVALIACAO', ds_comando_w, 'nr_seq_avaliacao_p='	|| nr_seq_avaliacao_p	|| ds_sep_bv_w ||
						'nr_seq_item_p='	|| nr_seq_item_p	|| ds_sep_bv_w );

if (ie_resultado_w = 'L') then
	begin
	open c01;
	loop
	fetch	c01 into
		nr_seq_item_refer_w,
		qt_resultado_refer_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	replace(ds_complemento_w, '&' || to_char(nr_seq_item_refer_w) || '&', to_char(qt_resultado_refer_w))
		into STRICT	ds_complemento_w
		;
		end;
	end loop;
	close c01;

	ds_complemento_w	:= replace(ds_complemento_w, ',','.');

	qt_resultado_refer_w := obter_valor_dinamico('select ' || ds_complemento_w || ' from dual ', qt_resultado_refer_w);
	qt_retorno_p		:= qt_resultado_refer_w;
	end;
end if;

if (upper(nm_tabela_p) = 'MED_AVALIACAO_RESULT')
and (nr_seq_avaliacao_p IS NOT NULL AND nr_seq_avaliacao_p::text <> '') then
	delete from med_avaliacao_result a
	where 		a.nr_seq_avaliacao = nr_seq_avaliacao_p
	and not exists (	SELECT 1
						from med_item_avaliar b,
						med_tipo_avaliacao c,
						med_avaliacao_paciente d
						where a.nr_seq_item = b.nr_sequencia
						and b.nr_seq_tipo = c.nr_sequencia
						and c.nr_sequencia = d.nr_seq_tipo_avaliacao
						and d.nr_sequencia = nr_seq_avaliacao_p);
	/*Remover resultados que não pertencem ao tipo de avaliação que está sendo preenchido*/

end if;


if (ds_resultado_p IS NOT NULL AND ds_resultado_p::text <> '') or (qt_resultado_w IS NOT NULL AND qt_resultado_w::text <> '') or (coalesce(qt_resultado_w,0) > 0) then
	begin

	ds_comando_w	:= 	' insert into ' || nm_tabela_p ||
				'(' || nm_atributo_avaliacao_w || ' , nr_seq_item, dt_atualizacao, ' ||
				' nm_usuario, qt_resultado, ds_resultado) values (' ||
				' :nr_seq_avaliacao_p, :nr_seq_item_p, ' ||
				' sysdate, :nm_usuario_p, :qt_resultado_w, :ds_resultado_p)';

	CALL exec_sql_dinamico_bv('AVALIACAO', ds_comando_w,	'nr_seq_avaliacao_p='	|| to_char(nr_seq_avaliacao_p) || ds_sep_bv_w ||
							'nr_seq_item_p='		|| to_char(nr_seq_item_p) || ds_sep_bv_w ||
							'nm_usuario_p='		|| nm_usuario_p || ds_sep_bv_w ||
							'qt_resultado_w='		|| qt_resultado_w || ds_sep_bv_w ||
							'ds_resultado_p='		|| ds_resultado_p || ds_sep_bv_w);
	end;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_avaliacao_medica ( nm_tabela_p text, nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, qt_resultado_p text, ds_resultado_p text, nm_usuario_p text, qt_retorno_p INOUT bigint, nm_atributo_p text default null) FROM PUBLIC;
