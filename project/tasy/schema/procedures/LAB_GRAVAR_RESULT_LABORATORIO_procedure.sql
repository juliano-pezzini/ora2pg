-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_gravar_result_laboratorio ( nr_prescricao_p bigint, nr_seq_prescr_p INOUT bigint, cd_exame_p text, ds_resultado_p text, nm_usuario_p text, ie_final_p text default 'S', ie_imp_result_branco_p text default 'N') AS $body$
DECLARE


/*
*  The variable ie_imp_result_branco_p had to be created to return the nr_seq_exame value
*  without recording the result. In this specific case, it had to be done due to the time that
*  would've been spent correcting it in a cleaner way.
*/
nr_seq_prescr_w				bigint;
ie_exame_w					smallint;
nr_seq_exame_w				bigint;
nr_seq_superior_w			bigint;
nr_seq_exame_origem_w 		bigint;

nr_seq_prescr_tmp_w			bigint;

ds_resultado_w				varchar(32767);
ie_manter_result_lab_w		varchar(1) := 'N';


C01 CURSOR FOR
	SELECT	1,
		nr_seq_exame,
		nr_seq_superior,
		null
	from	exame_laboratorio
	where coalesce(cd_exame_integracao, cd_exame) = cd_exame_p
	and ie_situacao = 'A'
	
union

	SELECT	2,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame as nr_seq_exame_origem
	from	exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	where	a.nr_seq_formato	= b.nr_seq_formato
	  and	b.nr_seq_exame		= c.nr_seq_exame
	  and	coalesce(c.cd_exame_integracao, c.cd_exame) = cd_exame_p
	  and 	c.ie_situacao = 'A'
	
union

	select	3,
		nr_seq_exame,
		nr_seq_superior,
		null
	from	exame_laboratorio
	where coalesce(cd_exame_integracao, cd_exame) = replace(cd_exame_p, 'URG', '')
	and ie_situacao = 'A'
	
union

	select	4,
		c.nr_seq_exame,
		a.nr_seq_exame,
		c.nr_seq_exame as nr_seq_exame_origem
	from	exame_lab_format a,
		exame_lab_format_item b,
		exame_laboratorio c
	where	a.nr_seq_formato	= b.nr_seq_formato
	  and	b.nr_seq_exame		= c.nr_seq_exame
	  and	coalesce(c.cd_exame_integracao, c.cd_exame) = replace(cd_exame_p, 'URG', '')
	  and 	c.ie_situacao = 'A'
	
union

	select	5,
		e.nr_seq_exame,
		e.nr_seq_superior,
		null
	from	exame_laboratorio e
	where	e.nr_seq_exame 	= obter_equip_exame_integracao(cd_exame_p,'FLEURY',1) --Tratamento utilizado pelo samaritano / fleury
	and 	e.ie_situacao = 'A'
	order by 1, 2;


BEGIN

nr_seq_prescr_w   := nr_seq_prescr_p;

if (coalesce(nr_seq_prescr_w::text, '') = '') and (cd_exame_p IS NOT NULL AND cd_exame_p::text <> '') then
	
	open C01;
	loop
	fetch C01 into	ie_exame_w,
			nr_seq_exame_w,
			nr_seq_superior_w,
			nr_seq_exame_origem_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		
	
		select min(coalesce(nr_sequencia, null))
		into STRICT	nr_seq_prescr_w
		from	prescr_procedimento
		where nr_prescricao		= trim(both nr_prescricao_p)
		  and nr_seq_exame		= nr_seq_exame_w;

		if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') and (coalesce(nr_seq_prescr_w::text, '') = '') then
			
			
			select	max(coalesce(nr_sequencia, null))
			into STRICT	nr_seq_prescr_w
			from	prescr_procedimento
			where	nr_prescricao = trim(both nr_prescricao_p)
			and	ie_status_atend >= 30
			and	nr_seq_exame = nr_seq_superior_w;
		
		  
			if (coalesce(nr_seq_prescr_w::text, '') = '') then
			
				select	max(coalesce(nr_sequencia, null))
				into STRICT	nr_seq_prescr_w
				from	prescr_procedimento
				where	nr_prescricao = trim(both nr_prescricao_p)
				and	nr_seq_exame = nr_seq_superior_w;
				
			end if;
			
			nr_seq_exame_w	:= nr_seq_superior_w;
			
		end if;
	
		if (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then
			exit;
		end if;

	end loop;
	close C01;
	
elsif (cd_exame_p IS NOT NULL AND cd_exame_p::text <> '') then

	open C01;
	loop
	fetch C01 into	ie_exame_w,
			nr_seq_exame_w,
			nr_seq_superior_w,
			nr_seq_exame_origem_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		
	
		select min(coalesce(nr_sequencia, null))
		into STRICT	nr_seq_prescr_tmp_w
		from	prescr_procedimento
		where nr_prescricao		= trim(both nr_prescricao_p)
		  and nr_seq_exame		= nr_seq_exame_w;

		if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') and (coalesce(nr_seq_prescr_tmp_w::text, '') = '') then
			
			
			select	max(coalesce(nr_sequencia, null))
			into STRICT	nr_seq_prescr_tmp_w
			from	prescr_procedimento
			where	nr_prescricao = trim(both nr_prescricao_p)
			and	ie_status_atend >= 30
			and	nr_seq_exame = nr_seq_superior_w;
		
		  
			if (coalesce(nr_seq_prescr_tmp_w::text, '') = '') then
			
				select	max(coalesce(nr_sequencia, null))
				into STRICT	nr_seq_prescr_tmp_w
				from	prescr_procedimento
				where	nr_prescricao = trim(both nr_prescricao_p)
				and	nr_seq_exame = nr_seq_superior_w;
				
			end if;
			
			nr_seq_exame_w	:= nr_seq_superior_w;
			
		end if;
	
		if (nr_seq_prescr_tmp_w IS NOT NULL AND nr_seq_prescr_tmp_w::text <> '') then
			exit;
		end if;

	end loop;
	close C01;

end if;

if (ie_imp_result_branco_p = 'S') then
  nr_seq_prescr_p := nr_seq_prescr_w;
  return;
end if;

select	coalesce(max(a.ie_manter_resultado_ws),'N')
into STRICT	ie_manter_result_lab_w
from	lab_parametro a,
		prescr_medica b
where	a.cd_estabelecimento = b.cd_estabelecimento
and		b.nr_prescricao = nr_prescricao_p;


if (ie_manter_result_lab_w = 'N') then
	ds_resultado_w	:= 'NR_SEQ_EXAME=' || TO_CHAR(coalesce(nr_seq_exame_origem_w,nr_seq_exame_w)) || ';' || ds_resultado_p;
else
	ds_resultado_w	:= ds_resultado_p;
end if;

nr_seq_prescr_p	:= nr_seq_prescr_w;

if (coalesce(nr_seq_prescr_w::text, '') = '') then
	-- 'A sequencia da prescricao nao foi encontrada. Prescricao:' || nr_prescricao_p  || 'Exame: ' || cd_exame_p ||' #@#@');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264074,'NR_PRESCRICAO='||nr_prescricao_p||';CD_EXAME='||cd_exame_p);
end if;

CALL Gravar_Result_Laboratorio(   nr_prescricao_p,  nr_seq_prescr_w,
                             ds_resultado_w,         nm_usuario_p, ie_final_p, cd_exame_p, 'N', coalesce(nr_seq_exame_origem_w,nr_seq_exame_w));

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_gravar_result_laboratorio ( nr_prescricao_p bigint, nr_seq_prescr_p INOUT bigint, cd_exame_p text, ds_resultado_p text, nm_usuario_p text, ie_final_p text default 'S', ie_imp_result_branco_p text default 'N') FROM PUBLIC;
