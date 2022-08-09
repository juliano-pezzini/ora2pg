-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_unico_cme_agenda (nm_usuario_p text, nr_sequencia_p bigint, nr_seq_proc_interno_p bigint, cd_estab_cme_p bigint, cd_especialidade_p bigint, cd_medico_p text, ie_GerarCMEIndividualizado_p text, ie_tem_medico_p text, ie_consiste_cme_p text, ds_erro_p INOUT text ) AS $body$
DECLARE

			 
ds_insert_w 			varchar(1);
cd_medico_conjunto_w	varchar(10);
NR_SEQ_CONJUNTO_W		bigint;		
qt_conjunto_w			bigint;
ie_obrigatorio_w		varchar(1);
nr_seq_grupo_w			bigint;
DS_ERRO_CME_W			varchar(255);
nr_sequencia_w			bigint;
qt_anos_pac_w			smallint;
qt_meses_pac_w			smallint;
qt_total_meses_pac_w	smallint;
			
			 
c01 CURSOR FOR 
	SELECT		a.nr_seq_conjunto, 
			a.qt_conjunto, 
			coalesce(a.ie_obrigatorio,'S'), 
			0 nr_seq_grupo 
from		proc_interno_cme a, 
		cm_conjunto b 
where		a.nr_seq_conjunto = b.nr_sequencia 
and		coalesce(b.ie_situacao,'A') = 'A' 
and		a.nr_seq_proc_interno	=	nr_seq_proc_interno_p 
and 		coalesce(qt_total_meses_pac_w,0) between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999) 
and			coalesce(a.cd_medico::text, '') = '' 
and			coalesce(a.NR_SEQ_CLASSIF::text, '') = '' 
and			coalesce(a.NR_SEQ_GRUPO::text, '') = ''	 
and			((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estab_cme_p)) 
and			((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_p)) 
and 		not exists (	SELECT	1 
						from	agenda_pac_cme x 
						where	x.nr_seq_agenda		=	nr_sequencia_p 
						and	x.nr_seq_conjunto	=	a.nr_seq_conjunto) 

union
 
select		a.nr_seq_conjunto, 
			a.qt_conjunto, 
			coalesce(a.ie_obrigatorio,'S'), 
			0 nr_seq_grupo 
from		proc_interno_cme a, 
		cm_conjunto b 
where		a.nr_seq_conjunto = b.nr_sequencia 
and		coalesce(b.ie_situacao,'A') = 'A' 
and		a.nr_seq_proc_interno	=	nr_seq_proc_interno_p 
and			a.cd_medico		=	cd_medico_p 
and 		coalesce(qt_total_meses_pac_w,0) between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999) 
and			coalesce(a.NR_SEQ_CLASSIF::text, '') = '' 
and			coalesce(a.NR_SEQ_GRUPO::text, '') = '' 
and			((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estab_cme_p)) 
and			((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_p)) 
and 		not exists (	select	1 
						from	agenda_pac_cme x 
						where	x.nr_seq_agenda		=	nr_sequencia_p 
						and	x.nr_seq_conjunto	=	a.nr_seq_conjunto) 

union
 
select		b.nr_sequencia, 
			a.qt_conjunto, 
			coalesce(a.ie_obrigatorio,'S'), 
			0 nr_seq_grupo 
from		cm_conjunto b, proc_interno_cme a 
where		a.nr_seq_proc_interno				= nr_seq_proc_interno_p 
and 		coalesce(qt_total_meses_pac_w,0) between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999) 
and			coalesce(a.cd_medico, coalesce(cd_medico_p, 'X')) 	= coalesce(cd_medico_p,'X') 
and			a.NR_SEQ_CLASSIF 				= b.NR_SEQ_CLASSIF 
and			coalesce(b.ie_situacao, 'A')				= 'A' 
and			coalesce(NR_SEQ_GRUPO::text, '') = '' 
and			((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estab_cme_p)) 
and			((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_p)) 
and 		not exists (	select	1 
						from	agenda_pac_cme x 
						where	x.nr_seq_agenda		=	nr_sequencia_p 
						and	x.nr_seq_conjunto	=	a.nr_seq_conjunto) 

union
 
select		b.nr_sequencia, 
			a.qt_conjunto, 
			coalesce(a.ie_obrigatorio,'S'), 
			c.NR_SEQ_GRUPO 
from		cm_grupo_conjunto d, 
			cm_grupo_classif c, 
			cm_conjunto b, 
			proc_interno_cme a 
where		a.nr_seq_proc_interno				= nr_seq_proc_interno_p 
and			c.nr_seq_grupo					= d.nr_sequencia 
and 		coalesce(qt_total_meses_pac_w,0) between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999) 
and			coalesce(a.cd_medico, coalesce(cd_medico_p, 'X')) 	= coalesce(cd_medico_p, 'X') 
and			b.NR_SEQ_CLASSIF 				= c.NR_SEQ_CLASSIFICACAO 
and			a.NR_SEQ_GRUPO  				= c.NR_SEQ_GRUPO 
and			coalesce(d.ie_situacao, 'A')				= 'A' 
and			coalesce(b.ie_situacao, 'A')				= 'A' 
and			((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estab_cme_p)) 
and			((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_p)) 
and 		not exists (	select	1 
						from	agenda_pac_cme x 
						where	x.nr_seq_agenda		=	nr_sequencia_p 
						and	x.nr_seq_conjunto	=	a.nr_seq_conjunto) 
and (ie_GerarCMEIndividualizado_p = 'N')								 

union
 
select		b.nr_sequencia, 
			a.qt_conjunto, 
			coalesce(a.ie_obrigatorio,'S'), 
			c.NR_SEQ_GRUPO 
from		cm_grupo_conjunto d, 
			cm_grupo_classif c, 
			cm_conjunto b, 
			proc_interno_cme a 
where		a.nr_seq_proc_interno					= nr_seq_proc_interno_p 
and			c.nr_seq_grupo							= d.nr_sequencia 
and 		coalesce(qt_total_meses_pac_w,0) between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999) 
and			((ie_tem_medico_p = 'S' AND a.cd_medico = cd_medico_p) or 
			((ie_tem_medico_p = 'N') and (coalesce(a.cd_medico::text, '') = ''))) 
and			b.NR_SEQ_CLASSIF 						= c.NR_SEQ_CLASSIFICACAO 
and			a.NR_SEQ_GRUPO  						= c.NR_SEQ_GRUPO 
and			coalesce(d.ie_situacao, 'A')					= 'A' 
and			coalesce(b.ie_situacao, 'A')					= 'A' 
and			((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estab_cme_p)) 
and			((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_p)) 
and 		not exists (	select	1 
						from	agenda_pac_cme x 
						where	x.nr_seq_agenda	=	nr_sequencia_p 
						and	x.nr_seq_conjunto	=	a.nr_seq_conjunto) 
and (ie_GerarCMEIndividualizado_p = 'S');					
 
 

BEGIN 
 
select max(qt_idade_paciente), 
		max(qt_idade_mes) 
into STRICT	qt_anos_pac_w,	 
    qt_meses_pac_w	 
from	agenda_paciente 
where	nr_sequencia 	= 	nr_sequencia_p;
 
qt_total_meses_pac_w := (qt_anos_pac_w * 12) + qt_meses_pac_w;
 
ds_insert_w := 'N';
 
open c01;
	loop 
		fetch c01	into 
			nr_seq_conjunto_w, 
			qt_conjunto_w, 
			ie_obrigatorio_w, 
			nr_seq_grupo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		select	coalesce(max(cd_medico),'0') 
		into STRICT	cd_medico_conjunto_w 
		from	cm_conjunto 
		where	nr_sequencia		= nr_seq_conjunto_w;
		 
		if (cd_medico_conjunto_w 	= '0') or (cd_medico_conjunto_w	= coalesce(cd_medico_p, cd_medico_conjunto_w)) then 
			begin 
		 
			/* Consistir conforme o parâmetro [101] */
 
			if (ie_consiste_cme_p <> 'N') AND (nr_seq_grupo_w = 0) then 
				begin 
				ds_erro_cme_w := cme_consistir_conj_agenda(nr_sequencia_p, nr_seq_conjunto_w, 'S', nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_erro_cme_w);
				end;
			end if;
			 
			if (ie_consiste_cme_p <> 'N') and (nr_seq_grupo_w > 0) then 
				begin 
				ds_erro_cme_w := cme_consistir_grupo_agenda(nr_sequencia_p, nr_seq_grupo_w, 'S', nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_erro_cme_w);
				end;
			end if;
 
 
			if (ie_consiste_cme_p = 'N') or (ie_consiste_cme_p = 'A') or 
				((ie_consiste_cme_p = 'S') and (coalesce(ds_erro_cme_w::text, '') = '')) then 
				begin 
				 
				select	nextval('agenda_pac_cme_seq') 
				into STRICT	nr_sequencia_w 
				;
 
				insert into agenda_pac_cme( 
					nr_seq_conjunto, 
					qt_conjunto, 
					nr_sequencia, 
					nr_seq_agenda, 
					dt_atualizacao, 
					nm_usuario, 
					ie_origem_inf, 
					ie_obrigatorio, 
					nr_seq_proc_interno, 
					nr_seq_grupo, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec) 
				values ( 
					nr_seq_conjunto_w, 
					qt_conjunto_w, 
					nr_sequencia_w, 
					nr_sequencia_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					'I', 
					ie_obrigatorio_w, 
					nr_seq_proc_interno_p, 
					CASE WHEN nr_seq_grupo_w=0 THEN null  ELSE nr_seq_grupo_w END , 
					clock_timestamp(), 
					nm_usuario_p);
					 
				ds_insert_w := 'S';	
					 
				exit;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c01;
	 
	if (ds_insert_w = 'N') then 
		ds_erro_p := wheb_mensagem_pck.get_texto(278843);
	end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_unico_cme_agenda (nm_usuario_p text, nr_sequencia_p bigint, nr_seq_proc_interno_p bigint, cd_estab_cme_p bigint, cd_especialidade_p bigint, cd_medico_p text, ie_GerarCMEIndividualizado_p text, ie_tem_medico_p text, ie_consiste_cme_p text, ds_erro_p INOUT text ) FROM PUBLIC;
