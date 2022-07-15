-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_consiste_classif_item ( nr_seq_ageint_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_seq_proc_interno_w	bigint;
ie_exige_classif_w	varchar(1);
ds_erro_w		varchar(2000);
ds_proc_interno_w	varchar(100);
nr_classificacao_agend_w	bigint;

C01 CURSOR FOR
	SELECT	nr_Seq_proc_interno,
		substr(obter_desc_proc_interno(nr_seq_proc_interno),1,100),
		Ageint_obter_se_exige_classif(nr_seq_proc_interno),
		nr_classificacao_agend
	from	agenda_integrada_item
	where	nr_seq_agenda_int	= nr_seq_ageint_p
	and	ie_tipo_agendamento	= 'E'
	and	coalesce(ie_regra,0) not in (1,2,5)
	and	coalesce(ie_glosa,'X') not in ('T','E','R','B','H','Z')
	order by nr_seq_proc_interno;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_proc_interno_w,
	ds_proc_interno_w,
	ie_exige_classif_w,
	nr_classificacao_agend_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_exige_classif_w = 'S') and (coalesce(nr_classificacao_agend_w::text, '') = '') then
		ds_erro_w	:= ds_erro_w || nr_seq_proc_interno_w || ' - ' || ds_proc_interno_w || ', ';
	end if;
	end;
end loop;
close C01;

ds_erro_p	:= substr(ds_erro_w, 1, length(ds_Erro_w) - 2);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_consiste_classif_item ( nr_seq_ageint_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

