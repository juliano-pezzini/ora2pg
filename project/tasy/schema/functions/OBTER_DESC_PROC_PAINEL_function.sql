-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proc_painel ( nr_sequencia_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1000);
ds_procedimento_w	varchar(255);
ds_lado_w		varchar(255);
ds_proc_adic_w		varchar(255);
ds_proc_adic_ww	varchar(255);
ds_exame_curto_w	varchar(255);
vl_parametro_w		varchar(255);
cd_procedimento_tuss_w	bigint;
ie_origem_proc_tuss_w	bigint;
nr_seq_proc_interno_w	proc_interno.nr_sequencia%type;
ie_origem_proced_w		proc_interno.ie_origem_proced%type;
cd_procedimento_w			proc_interno.cd_procedimento%type;
ie_lado_w					agenda_paciente.ie_lado%type;
ds_cirurgia_w				agenda_paciente.ds_cirurgia%type;


/* ie_opcao_p
1 = Procedimento
2 = Procedimento+Descrição+Lado+Proc adicionais
3 = Descrição+Lado
*/
BEGIN


select	max(nr_seq_proc_interno),
			max(ie_origem_proced),
			max(cd_procedimento),
			max(ie_lado),
			max(substr(ds_cirurgia,1,255)),
			CASE WHEN ie_opcao_p=2 THEN max(substr(obter_proced_lado_agenda(nr_sequencia),1,255))  ELSE null END
into STRICT		nr_seq_proc_interno_w,
			ie_origem_proced_w,
			cd_procedimento_w,
			ie_lado_w,
			ds_cirurgia_w,
			ds_proc_adic_w
from		agenda_paciente
where		nr_sequencia = nr_sequencia_p;


case ie_opcao_p
		when 1 then
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_proc_exame(nr_seq_proc_interno_w),1,255);
			elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			end if;
			ds_retorno_w := ds_procedimento_w;
		when 2 then
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_proc_exame(nr_seq_proc_interno_w),1,255);
			elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			end if;
			if (ie_lado_w IS NOT NULL AND ie_lado_w::text <> '') then
				ds_lado_w := '. '||obter_desc_expressao(292416,'Lado')||': ' || substr(obter_valor_dominio(1372,ie_lado_w),1,20);
			end if;
			if (ds_proc_adic_w IS NOT NULL AND ds_proc_adic_w::text <> '') then
				ds_proc_adic_ww := substr('. '||substr(ds_proc_adic_w,1,length(ds_proc_adic_w)-2),1,255);
			end if;
			ds_retorno_w := substr(ds_procedimento_w || ' ' || ds_cirurgia_w || ds_lado_w || ds_proc_adic_ww,1,255);
		when 3 then
			if (ie_lado_w IS NOT NULL AND ie_lado_w::text <> '') then
				ds_lado_w := '. '||obter_desc_expressao(292416,'Lado')||': ' || substr(obter_valor_dominio(1372,ie_lado_w),1,20);
			end if;
			ds_retorno_w	:= substr(ds_cirurgia_w || ds_lado_w,1,255);
		when 4 then
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_proc_exame(nr_seq_proc_interno_w),1,255);
			elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			end if;
			if (ie_lado_w IS NOT NULL AND ie_lado_w::text <> '') then
				ds_lado_w := '. '||obter_desc_expressao(292416,'Lado')||': ' || substr(obter_valor_dominio(1372,ie_lado_w),1,20);
			end if;
			ds_retorno_w	:= substr(ds_procedimento_w || ' ' || ds_lado_w,1,255);
		when 5 then
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
				select	substr(max(ds_proc_exame),1,255),
							substr(max(ds_exame_curto),1,255)
				into STRICT		ds_procedimento_w,
							ds_exame_curto_w
				from		proc_interno
				where		nr_sequencia = nr_seq_proc_interno_w;
			elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				ds_procedimento_w := substr(obter_desc_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			end if;
			ds_retorno_w	:= substr(ds_exame_curto_w || ' ' || ds_procedimento_w,1,255);
		when 6 then
			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
				select	max(cd_procedimento_tuss),
							max(ie_origem_proc_tuss)
				into STRICT		cd_procedimento_tuss_w,
							ie_origem_proc_tuss_w
				from		proc_interno
				where		nr_sequencia = nr_seq_proc_interno_w;
				if (cd_procedimento_tuss_w IS NOT NULL AND cd_procedimento_tuss_w::text <> '') and (ie_origem_proc_tuss_w IS NOT NULL AND ie_origem_proc_tuss_w::text <> '') then
					ds_retorno_w := substr(obter_descricao_procedimento(cd_procedimento_tuss_w, ie_origem_proc_tuss_w),1,255);
				end if;
			end if;
		end case;
*/
/*



select	max(nvl(b.ds_proc_exame,c.DS_PROCEDIMENTO)) ds_procedimento,
			max(substr(a.ds_cirurgia,1,255)),
			max(decode(a.ie_lado,null,null,'. Lado: ') || substr(obter_valor_dominio(1372,a.ie_lado),1,20)),
			decode(ie_opcao_p,2,max(substr(obter_proced_lado_agenda(a.nr_sequencia),1,255)),null) ds_proced_lado,
			--max(substr(decode(obter_proced_lado_agenda(a.nr_sequencia), null, null, '. ') || substr(obter_proced_lado_agenda(a.nr_sequencia),1,length(obter_proced_lado_agenda(a.nr_sequencia))-2),1,255)),
			max(substr(b.ds_exame_curto,1,255)),
			max(b.cd_procedimento_tuss),
			max(b.ie_origem_proc_tuss)
into		ds_procedimento_w,
			ds_cirurgia_w,
			ds_lado_w,
			ds_proc_adic_w,
			ds_exame_curto_w,
			cd_procedimento_tuss_w,
			ie_origem_proc_tuss_w
from		proc_interno b,
			procedimento c,
			agenda_paciente a
where		b.nr_sequencia(+) 		= a.nr_seq_proc_interno
and     	c.cd_procedimento(+) 	= a.cd_procedimento
and 		c.ie_origem_proced(+) 	= a.ie_origem_proced
and		a.nr_sequencia 			= nr_sequencia_p;



if	(ie_opcao_p = 1) then
	ds_retorno_w	:= substr(ds_procedimento_w,1,255);
elsif	(ie_opcao_p = 2) then
	ds_retorno_w	:= substr(ds_procedimento_w || ' ' || ds_cirurgia_w || ds_lado_w || ds_proc_adic_ww,1,255);
elsif	(ie_opcao_p = 3) then
	ds_retorno_w	:= substr(ds_cirurgia_w || ds_lado_w,1,255);
elsif	(ie_opcao_p = 4) then
	ds_retorno_w	:= substr(ds_procedimento_w || ' ' || ds_lado_w,1,255);
elsif	(ie_opcao_p = 5) then
	ds_retorno_w	:= substr(ds_exame_curto_w || ' ' || ds_procedimento_w,1,255);
elsif	(ie_opcao_p = 6) then
	ds_retorno_w	:= substr(obter_descricao_procedimento(cd_procedimento_tuss_w, ie_origem_proc_tuss_w),1,255);
end if;
*/
return substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proc_painel ( nr_sequencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;

