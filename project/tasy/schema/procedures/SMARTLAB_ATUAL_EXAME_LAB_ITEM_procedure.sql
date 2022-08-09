-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE smartlab_atual_exame_lab_item (nr_prescricao_p bigint, cd_exame_p text, cd_analito_p text, ds_resultado_p text, ds_observacao_p text, dt_resultado_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_seq_prescricao_w	bigint;
nr_seq_exame_w		bigint;
cd_analito_w		varchar(20);
nr_seq_resultado_w		bigint;
ie_formato_resultado_w	varchar(3);
qt_resultado_w		double precision	:= null;
pr_resultado_w		double precision	:= null;
ds_resultado_w		varchar(4000)	:= null;
	

BEGIN 
 
-- Busca sequência da prescrição 
select 	coalesce(max(a.nr_sequencia),0), 
	coalesce(max(a.nr_seq_exame),0) 
into STRICT 	nr_seq_prescricao_w, 
	nr_seq_exame_w 
from 	prescr_procedimento a, 
	exame_laboratorio b 
where 	a.nr_seq_exame = b.nr_seq_exame 
and	coalesce(b.ie_situacao,'A') <> 'I' 
and	a.nr_prescricao = nr_prescricao_p 
and	upper(coalesce(b.cd_exame_integracao,b.cd_exame)) = upper(cd_exame_p);
 
if (nr_seq_prescricao_w = 0) then 
	--Não foi possível encontrar o exame ' ||cd_exame_p||', na prescrição '||to_char(nr_prescricao_p) 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(233241,'CD_EXAME='||to_char(cd_exame_p)||';'||'NR_PRESCRICAO='||to_char(nr_prescricao_p));
end if;
 
-- Busca código do analito 
select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
into STRICT	cd_analito_w 
from	exame_laboratorio e 
where	e.nr_seq_exame = (SELECT nr_seq_exame 
			 from equipamento_lab b, 
				lab_exame_equip a 
			 WHERE	a.cd_equipamento = b.cd_equipamento 
			 AND	a.cd_exame_equip = cd_analito_p 
			 AND	upper(b.ds_sigla)	 = 'SMART' 
			 AND	a.nr_seq_exame = nr_seq_exame_w);WITH RECURSIVE cte AS (

 
--gravar log tasy(9001,'1 - nr_prescricao_p: '||nr_prescricao_p||' cd_analito_w: '||cd_analito_w||' cd_analito_p: '||cd_analito_p||' nr_seq_exame_w: '||nr_seq_exame_w,'tbschulz'); 
--commit; 
 
if (coalesce(cd_analito_w::text, '') = '') then 
 
	select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
	into STRICT	cd_analito_w 
	from	exame_laboratorio e WHERE nr_seq_superior = nr_seq_exame_w
  UNION ALL
 
 

 
if (coalesce(cd_analito_w::text, '') = '') then 
 
	select	max(coalesce(e.cd_exame_integracao, e.cd_exame)) 
	into STRICT	cd_analito_w 
	from	exame_laboratorio e JOIN cte c ON (c.prior nr_seq_exame = e.nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_exame = (SELECT nr_seq_exame 
				from equipamento_lab b, 
				   lab_exame_equip a 
				WHERE	a.cd_equipamento = b.cd_equipamento 
				AND	a.cd_exame_equip = cd_analito_p 
				AND	upper(b.ds_sigla)	 = 'SMART' 
				AND	a.nr_seq_exame = e.nr_seq_exame);
;
 
 
end if;WITH RECURSIVE cte AS (

 
if (cd_analito_w IS NOT NULL AND cd_analito_w::text <> '') then 
 
	select	max(ie_formato_resultado) 
	into STRICT	ie_formato_resultado_w 
	from	exame_laboratorio WHERE nr_seq_superior = nr_seq_exame_w
  UNION ALL
 
 
if (cd_analito_w IS NOT NULL AND cd_analito_w::text <> '') then 
 
	select	max(ie_formato_resultado) 
	into STRICT	ie_formato_resultado_w 
	from	exame_laboratorio JOIN cte c ON (c.prior nr_seq_exame = nr_seq_superior)

) SELECT * FROM cte WHERE coalesce(cd_exame_integracao, cd_exame) = cd_analito_w;
;
	 
	ds_resultado_w := ds_resultado_p;
	 
	begin 
		if (ie_formato_resultado_w = 'V') then 
			qt_resultado_w	:= (ds_resultado_w)::numeric;
			ds_resultado_w	:= '';
		elsif (ie_formato_resultado_w = 'P') then 
			pr_resultado_w	:= (ds_resultado_w)::numeric;
			ds_resultado_w	:= '';
		end if;
	exception 
	when data_exception then 
		--Não foi possível inserir o resultado no exame ' ||cd_analito_w||' favor verificar o formato do mesmo. 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(233242,'CD_ANALITO='||cd_analito_w);
	end;
	 
	--gravar log tasy(9001,'2 - nr_prescricao_p: '||nr_prescricao_p||' ie_formato_resultado_w: '||ie_formato_resultado_w||' qt_resultado_w: '||qt_resultado_w||' ds_resultado_w: '||ds_resultado_w||' cd_analito_w: '||cd_analito_w,'tbschulz'); 
	--commit; 
	 
	ds_erro_p := Atualizar_Lab_Result_Item(	nr_prescricao_p, nr_seq_prescricao_w, cd_analito_w, qt_resultado_w, pr_resultado_w, ds_resultado_w, ds_observacao_p, null, null, nm_usuario_p, null, null, null, null, null, ds_erro_p);
 
	-- Busca o resultado 
	select 	nr_seq_resultado 
	into STRICT  	nr_seq_resultado_w 	 
	from 	exame_lab_resultado 
	where 	nr_prescricao = nr_prescricao_p;
 
	-- atualiza dt aprovacao para ficar pendente de aprovação 
	update 	exame_lab_result_item 
	set 	dt_aprovacao  = NULL 
	where 	nr_seq_resultado = nr_seq_resultado_w;
	 
	-- atualiza método do exame 
	update 	exame_lab_result_item 
	set 	nr_seq_metodo 	= obter_metodo_regra(nr_prescricao_p, nr_seq_exame) 
	where 	nr_seq_resultado = nr_seq_resultado_w 
	and	coalesce(nr_seq_metodo::text, '') = '';
	 
	commit;	
	 
end if;
		 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE smartlab_atual_exame_lab_item (nr_prescricao_p bigint, cd_exame_p text, cd_analito_p text, ds_resultado_p text, ds_observacao_p text, dt_resultado_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
