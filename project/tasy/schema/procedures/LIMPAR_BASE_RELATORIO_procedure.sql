-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_base_relatorio (qt_dias_p bigint) AS $body$
DECLARE

 
nr_sequencia_w	bigint;
ds_erro_w	varchar(255);

c01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	relatorio 
	where	(lower(ds_titulo) like '%teste%' 
	or	lower(ds_titulo) like '%cópia%' 
	or	((lower(ds_titulo) like 'novo%') and (cd_classif_relat like 'W%') and (cd_relatorio <> 672)) 
	or	coalesce(trim(both ds_titulo)::text, '') = '') 
	and	cd_relatorio not in (170,46,1005,222,1181);
	
c02 CURSOR FOR	 
	SELECT	a.nr_sequencia 
	from	relatorio a 
	where	a.cd_classif_relat like 'C%' 
	and	a.dt_atualizacao < clock_timestamp() - qt_dias_p 
	and	not exists (	SELECT	1 
				from	banda_relatorio b 
				where	a.nr_sequencia = b.nr_seq_relatorio 
				and	b.DT_ATUALIZACAO > clock_timestamp() - qt_dias_p) 
	and	not exists (	select	1 
				from	banda_relatorio c, 
					banda_relat_campo d 
				where	a.nr_sequencia = c.nr_seq_relatorio 
				and	c.nr_sequencia = d.nr_seq_banda 
				and	d.DT_ATUALIZACAO > clock_timestamp() - qt_dias_p);


BEGIN 
 
 
if (user = 'CORP') then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(280786);
elsif (obter_se_base_wheb = 'N') then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(283275);
end if;
 
open C01;
loop 
fetch C01 into 
  	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	delete	from relatorio 
	where	nr_sequencia = nr_sequencia_w;	
end loop;
close	C01;
 
open C02;
loop 
fetch C02 into 
  	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin	 
	begin 
		delete	from relatorio 
		where	nr_sequencia = nr_sequencia_w;	
	exception	 
	when others then 
	null;
	/*ds_erro_w	:= sqlerrm(sqlcode); 
	insert into 
		logxxx_tasy (	DT_ATUALIZACAO, 
				NM_USUARIO,       
				CD_LOG,         
				DS_LOG) 
	values 
				(sysdate, 
				'Tasy', 
				1, 
				'SeqRelatorio=' || nr_sequencia_w || ' Erro: ' || ds_erro_W);*/
 
	end;
	end;
end loop;
close	C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_base_relatorio (qt_dias_p bigint) FROM PUBLIC;

