-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_j200_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
ds_linha_w			varchar(8000);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
nr_seq_demo_dmpl_w		ctb_sped_controle.nr_seq_demo_dmpl%type;
nr_seq_demo_dlpa_w		ctb_sped_controle.nr_seq_demo_dlpa%type;
dt_ano_w							ctb_regra_sped.dt_ano%type;
cd_versao_w							ctb_regra_sped.cd_versao%type;
sep_w				varchar(1) := '|';
tp_registro_w			varchar(15) := 'J200';

C01 CURSOR FOR
	SELECT 	b.nr_seq_rubrica cd_hist_fato_contabil,
		b.ds_rubrica ds_fato_contabil
	from 	ctb_demo_rubrica_v b
	where 	b.nr_seq_demo in (nr_seq_demo_dmpl_w,nr_seq_demo_dlpa_w)
	order by 2;

c01_w c01%rowtype;

C02 CURSOR FOR
	SELECT	nr_seq_mutacao_pl cd_hist_fato_contabil,
		ds_linha ds_fato_contabil
	from	ctb_dmpl_movimento_v
	where	nr_seq_dmpl = nr_seq_demo_dmpl_w
	and 	(nr_seq_mutacao_pl IS NOT NULL AND nr_seq_mutacao_pl::text <> '')
	order by 2;

c02_w c02%rowtype;


BEGIN

select		max(b.dt_ano),
			max(b.cd_versao)
into STRICT		dt_ano_w,
			cd_versao_w
from		ctb_sped_controle a,
		ctb_regra_sped b
where	 	a.nr_seq_regra_sped = b.nr_sequencia
and 		a.nr_sequencia = nr_seq_controle_p;

if (coalesce(cd_versao_w,'9.0') not in ('9.0', '8.0', '7.0')) then
	if (dt_ano_w >= TO_DATE('31/12/2014', 'dd/mm/yyyy')) then
		begin
		select	a.nr_seq_dmpl
		into STRICT	nr_seq_demo_dmpl_w
		from	ctb_sped_controle a
		where	 a.nr_sequencia = nr_seq_controle_p;
	
		open C02;
		loop
		fetch C02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
	
			ds_linha_w	:= substr(	sep_w || tp_registro_w 			||
						sep_w || c02_w.cd_hist_fato_contabil 	||
						sep_w || coalesce(c02_w.ds_fato_contabil, 'Nao identificado pelo usuario') 	|| sep_w ,1,8000);
	
			ds_arquivo_w		:= substr(ds_linha_w,1,4000);
			ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			nr_linha_w		:= nr_linha_w + 1;
	
			insert into ctb_sped_registro(
				nr_sequencia,
				ds_arquivo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_controle_sped,
				ds_arquivo_compl,
					cd_registro,
				nr_linha)
			values (	nr_seq_registro_w,
				ds_arquivo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_controle_p,
				ds_compl_arquivo_w,
				tp_registro_w,
				nr_linha_w);
	
			end;
		end loop;
		close C02;
	
		end;
	else
		begin
	
		select	max(a.nr_seq_demo_dmpl),
			max(a.nr_seq_demo_dlpa)
		into STRICT	nr_seq_demo_dmpl_w,
			nr_seq_demo_dlpa_w
		from	ctb_sped_controle a
		where	 a.nr_sequencia = nr_seq_controle_p;
	
		open C01;
		loop
		fetch C01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
	
			ds_linha_w	:= substr(	sep_w || tp_registro_w 			||
						sep_w || c01_w.cd_hist_fato_contabil 	||
						sep_w || coalesce(c01_w.ds_fato_contabil, 'Nao identificado pelo usuario') 	|| sep_w ,1,8000);
	
			ds_arquivo_w		:= substr(ds_linha_w,1,4000);
			ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			nr_linha_w		:= nr_linha_w + 1;
	
			insert into ctb_sped_registro(
				nr_sequencia,
				ds_arquivo,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_controle_sped,
				ds_arquivo_compl,
					cd_registro,
				nr_linha)
			values (	nr_seq_registro_w,
				ds_arquivo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_controle_p,
				ds_compl_arquivo_w,
				tp_registro_w,
				nr_linha_w);
			end;
		end loop;
		close C01;
		end;
	end if;
end if;
commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_j200_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

