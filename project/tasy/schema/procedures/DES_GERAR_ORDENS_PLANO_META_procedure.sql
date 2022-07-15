-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_gerar_ordens_plano_meta (nr_seq_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_gerencia_w				bigint;
nr_seq_ordem_w					bigint;
ie_60_dias_w					varchar(10);
ie_45_dias_w					varchar(10);
ie_30_dias_w					varchar(10);
ie_15_dias_w					varchar(10);
ie_7_dias_w						varchar(10);
ie_semana_w						varchar(10);
ie_tipo_os_meta_w				varchar(10);
nr_seq_plano_os_w				bigint;
nr_seq_estagio_w				bigint;

C01 CURSOR FOR
		SELECT  a.nr_sequencia,
				a.nr_seq_estagio,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), to_date('01/01/2007','dd/mm/yyyy'), clock_timestamp() - interval '60 days')='S' THEN  'S'  ELSE '' END  ie_60_dias,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), clock_timestamp() - interval '59 days', clock_timestamp() - interval '45 days')='S' THEN  'S'  ELSE '' END  ie_45_dias,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), clock_timestamp() - interval '44 days', clock_timestamp() - interval '30 days')='S' THEN  'S'  ELSE '' END  ie_30_dias,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), clock_timestamp() - interval '29 days', clock_timestamp() - interval '15 days')='S' THEN  'S'  ELSE '' END  ie_15_dias,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), clock_timestamp() - interval '14 days', clock_timestamp() - interval '7 days')='S' THEN  'S'  ELSE '' END  ie_7_dias,
				CASE WHEN obter_se_data_periodo(trunc(a.dt_ordem_servico, 'dd'), clock_timestamp() - interval '6 days', clock_timestamp())='S' THEN  'S'  ELSE '' END  ie_semana
		from    gerencia_wheb c,
				grupo_desenvolvimento b,
				man_ordem_servico  a
		where  	b.nr_seq_gerencia	= c.nr_sequencia
		and		(('S' = 'N')  or (obter_se_os_pend_cliente(a.nr_sequencia) = 'N'))
		and	  	(('S' = 'N')  or (Obter_Se_OS_Desenv(a.nr_sequencia) = 'S'))
		and   	(('N' = 'N' and ie_status_ordem <> 3) or ('N' = 'S' and ie_status_ordem = 3))
		and   	a.nr_seq_grupo_des    = b.nr_sequencia
		and   	a.dt_ordem_servico < clock_timestamp()
		and   	substr(obter_se_ordem_vinc_projeto(a.nr_sequencia,'2'),1,1) = 'N'
		and 	c.nr_sequencia 	= nr_seq_gerencia_w
		order by 2,3,4,5;


BEGIN

delete from desenv_plano_meta_os
where nr_seq_plano = nr_seq_plano_p;

select	max(nr_seq_gerencia)
into STRICT	nr_seq_gerencia_w
from	desenvolvimento_plano_meta
where	nr_sequencia	= nr_seq_plano_p;

if (nr_seq_gerencia_w IS NOT NULL AND nr_seq_gerencia_w::text <> '') then
		begin

		open C01;
		loop
		fetch C01 into
			nr_seq_ordem_w,
			nr_seq_estagio_w,
			ie_60_dias_w,
			ie_45_dias_w,
			ie_30_dias_w,
			ie_15_dias_w,
			ie_7_dias_w,
			ie_semana_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (ie_60_dias_w = 'S') then
				ie_tipo_os_meta_w	:= '0';
			elsif (ie_45_dias_w = 'S') then
				ie_tipo_os_meta_w	:= '1';
			elsif (ie_30_dias_w = 'S') then
				ie_tipo_os_meta_w	:= '2';
			elsif (ie_15_dias_w = 'S') then
				ie_tipo_os_meta_w	:= '3';
			elsif (ie_7_dias_w = 'S') then
				ie_tipo_os_meta_w	:= '4';
			elsif (ie_semana_w = 'S') then
				ie_tipo_os_meta_w	:= '5';
			end if;

			select	nextval('desenv_plano_meta_os_seq')
			into STRICT	nr_seq_plano_os_w
			;

			insert 	into desenv_plano_meta_os(nr_sequencia,
					nr_seq_plano,
					nr_seq_ordem_serv,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_tipo_os_meta,
					nr_seq_estagio_orig)
			values (nr_seq_plano_os_w,
					nr_seq_plano_p,
					nr_seq_ordem_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ie_tipo_os_meta_w,
					nr_seq_estagio_w);

			end;
		end loop;
		close C01;

		update	desenvolvimento_plano_meta
		set		dt_geracao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_plano_p;

		end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_gerar_ordens_plano_meta (nr_seq_plano_p bigint, nm_usuario_p text) FROM PUBLIC;

