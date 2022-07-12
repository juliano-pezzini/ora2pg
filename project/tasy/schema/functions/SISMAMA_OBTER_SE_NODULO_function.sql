-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sismama_obter_se_nodulo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_nod_qsl_dir_w 	varchar(1);
ie_nod_qil_dir_w 	varchar(1);
ie_nod_qsm_dir_w 	varchar(1);
ie_nod_qim_dir_w 	varchar(1);
ie_nod_uqlat_dir_w 	varchar(1);
ie_nod_uqsup_dir_w 	varchar(1);
ie_nod_uqmed_dir_w 	varchar(1);
ie_nod_uqinf_dir_w 	varchar(1);
ie_nod_rra_dir_w 	varchar(1);
ie_nod_pa_dir_w 	varchar(1);
ie_nod_qsl_esq_w	varchar(1);
ie_nod_qil_esq_w 	varchar(1);
ie_nod_qsm_esq_w 	varchar(1);
ie_nod_qim_esq_w 	varchar(1);
ie_nod_uqlat_esq_w 	varchar(1);
ie_nod_uqsup_esq_w 	varchar(1);
ie_nod_uqmed_esq_w 	varchar(1);
ie_nod_uqinf_esq_w 	varchar(1);
ie_nod_rra_esq_w 	varchar(1);
ie_nod_pa_esq_w 	varchar(1);
ds_retorno_w		varchar(255);


BEGIN

select 	ie_nod_qsl_dir,
	ie_nod_qil_dir,
	ie_nod_qsm_dir,
	ie_nod_qim_dir,
	ie_nod_uqlat_dir,
	ie_nod_uqsup_dir,
	ie_nod_uqmed_dir,
	ie_nod_uqinf_dir,
	ie_nod_rra_dir,
	ie_nod_pa_dir,
	ie_nod_qsl_esq,
	ie_nod_qil_esq,
	ie_nod_qsm_esq,
	ie_nod_qim_esq,
	ie_nod_uqlat_esq,
	ie_nod_uqsup_esq,
	ie_nod_uqmed_esq,
	ie_nod_uqinf_esq,
	ie_nod_rra_esq,
	ie_nod_pa_esq
into STRICT	ie_nod_qsl_dir_w,
	ie_nod_qil_dir_w,
	ie_nod_qsm_dir_w,
	ie_nod_qim_dir_w,
	ie_nod_uqlat_dir_w,
	ie_nod_uqsup_dir_w,
	ie_nod_uqmed_dir_w,
	ie_nod_uqinf_dir_w,
	ie_nod_rra_dir_w,
	ie_nod_pa_dir_w,
	ie_nod_qsl_esq_w,
	ie_nod_qil_esq_w,
	ie_nod_qsm_esq_w,
	ie_nod_qim_esq_w,
	ie_nod_uqlat_esq_w,
	ie_nod_uqsup_esq_w,
	ie_nod_uqmed_esq_w,
	ie_nod_uqinf_esq_w,
	ie_nod_rra_esq_w,
	ie_nod_pa_esq_w
from	sismama_mam_ind_clinica x
where	x.nr_seq_sismama  = nr_sequencia_p;

if (ie_nod_qsl_dir_w = 'S') or (ie_nod_qil_dir_w = 'S') or (ie_nod_qsm_dir_w =  'S') or (ie_nod_qim_dir_w = 'S') or (ie_nod_uqlat_dir_w = 'S') or (ie_nod_uqsup_dir_w = 'S') or (ie_nod_uqmed_dir_w = 'S') or (ie_nod_uqinf_dir_w = 'S') or (ie_nod_rra_dir_w =  'S') or (ie_nod_pa_dir_w =  'S') or (ie_nod_qsl_esq_w = 'S') or (ie_nod_qil_esq_w =  'S') or (ie_nod_qsm_esq_w =  'S') or (ie_nod_qim_esq_w = 'S') or (ie_nod_uqlat_esq_w = 'S') or (ie_nod_uqsup_esq_w = 'S') or (ie_nod_uqmed_esq_w = 'S') or (ie_nod_uqinf_esq_w = 'S') or (ie_nod_rra_esq_w = 'S') or (ie_nod_pa_esq_w = 'S') then
	begin
	ds_retorno_w := 'nódulo';
	end;
end if;

if (ie_nod_qsl_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || 'QSL';
elsif (ie_nod_qil_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || 'QIL';
elsif (ie_nod_qsm_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QSM';
elsif (ie_nod_qim_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QIM';
elsif (ie_nod_uqlat_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQLat';
elsif (ie_nod_uqsup_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQSup';
elsif (ie_nod_uqmed_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQMed';
elsif (ie_nod_rra_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' RRA';
elsif (ie_nod_pa_dir_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' PA';
elsif (ie_nod_qsl_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QSL';
elsif (ie_nod_qil_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QIL';
elsif (ie_nod_qsm_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QSM';
elsif (ie_nod_qim_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' QIM';
elsif (ie_nod_uqlat_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQLat';
elsif (ie_nod_uqsup_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQSup';
elsif (ie_nod_uqmed_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQMed';
elsif (ie_nod_uqinf_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' UQInf';
elsif (ie_nod_rra_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' RRA';
elsif (ie_nod_pa_esq_w = 'S') then
	ds_retorno_w := ds_retorno_w || ' PA';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sismama_obter_se_nodulo (nr_sequencia_p bigint) FROM PUBLIC;
