-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_wdeptbeds_html ( dt_referencia_p timestamp, cd_setor unidade_atendimento.cd_setor_atendimento%type) AS $body$
DECLARE

  cd_setor_desejado_w		integer;
  cd_unidade_basica_w		varchar(20);
  cd_unidade_compl_w		varchar(20);
  dt_entrada_w			timestamp;
  dt_saida_w                 	timestamp;
  nr_sequencia_w             	bigint;
  dt_entrada_ant_w           	timestamp := clock_timestamp();
  dt_saida_ant_w             	timestamp := clock_timestamp();
  qt_dia_w                   	bigint;
  i                          	integer;
  ds_cor_w                   	varchar(20);
  nr_seq_suite_w             	bigint;
  qt_existe_registro_suite_w 	bigint;
  cd_setor_desejado_ant_w    	integer := '';
  cd_unidade_basica_ant_w    	varchar(20) := '';
  cd_unidade_compl_ant_w     	varchar(20) := '';
  dt_refer_w                 	timestamp;
  ie_status_w                	varchar(20);
  dia1_w                     	varchar(20);
  dia2_w                     	varchar(20);
  dia3_w                     	varchar(20);
  dia4_w                     	varchar(20);
  dia5_w                     	varchar(20);
  dia6_w                     	varchar(20);
  dia7_w                     	varchar(20);
  dia8_w                     	varchar(20);
  dia9_w                     	varchar(20);
  dia10_w                    	varchar(20);
  dia11_w                    	varchar(20);
  dia12_w                    	varchar(20);
  dia13_w                    	varchar(20);
  dia14_w                    	varchar(20);
  dia15_w                    	varchar(20);
  dia16_w                    	varchar(20);
  dia17_w                    	varchar(20);
  dia18_w                    	varchar(20);
  dia19_w                    	varchar(20);
  dia20_w                    	varchar(20);
  dia21_w                    	varchar(20);
  dia22_w                    	varchar(20);
  dia23_w                    	varchar(20);
  dia24_w                    	varchar(20);
  dia25_w                    	varchar(20);
  dia26_w                    	varchar(20);
  dia27_w                    	varchar(20);
  dia28_w                    	varchar(20);
  dia29_w                    	varchar(20);
  dia30_w                    	varchar(20);
  dia31_w                    	varchar(20);
  ds_cor_ant_w               	varchar(20);
  dt_referencia_w            	timestamp;
  counter                       integer := 0;

c01 CURSOR FOR
	SELECT	cd_setor_desejado,
		cd_unidade_basica,
		cd_unidade_compl,
		pkg_date_utils.start_of(dt_prevista,'DD',0) dt_entrada,
		pkg_date_utils.start_of(dt_prevista,'DD',0) + qt_dia dt_saida,
		coalesce(qt_dia,0) qt_dia,
		'O' as ie_status
	from	gestao_vaga a
	where (a.dt_prevista between pkg_date_utils.start_of(dt_referencia_p,'MONTH',0) and pkg_date_utils.end_of(dt_referencia_p, 'MONTH', 0))
	and	(a.cd_unidade_basica IS NOT NULL AND a.cd_unidade_basica::text <> '')
	and	obter_se_controla_leitos(a.cd_setor_desejado,a.cd_unidade_basica,a.cd_unidade_compl) = 'S'
	and	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
	and	a.cd_setor_desejado = cd_setor
	
union

	SELECT	cd_setor_desejado,
		cd_unidade_basica,
		cd_unidade_compl,
		pkg_date_utils.start_of(dt_referencia_p,'MONTH',0) dt_entrada,
		pkg_date_utils.start_of(dt_referencia_p,'DD') + (qt_dia - abs(pkg_date_utils.start_of(dt_prevista,'DD') - pkg_date_utils.aDD_MONTH(pkg_date_utils.start_of(pkg_date_utils.end_of(dt_referencia_p,'MONTH'), 'DD'), - 1)) - 1) dt_saida,
		(qt_dia - abs(trunc(to_date(dt_prevista,'DD/MM/YYYY'),'DD') - pkg_date_utils.aDD_MONTH(last_DAY(trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'DD')), - 1, 0)) - 1) qt_dia,
		'O' as ie_status
	from	gestao_vaga
	where	((pkg_date_utils.aDD_MONTH(dt_prevista + qt_dia - pkg_date_utils.extract_field('DAY', pkg_date_utils.end_of(dt_referencia_p, 'MONTH', 0)),1,0) between pkg_date_utils.start_of(dt_referencia_p,'MONTH',0) and pkg_date_utils.end_of(pkg_date_utils.aDD_MONTH(dt_referencia_p,12,0), 'MONTH', 0))
	and	((trunc(to_date(dt_prevista,'DD/MM/YYYY'),'MM')<> trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'MM'))
	and	(trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'DD') + (qt_dia - abs(trunc(to_date(dt_prevista,'DD/MM/YYYY'),'DD') - pkg_date_utils.aDD_MONTH(last_DAY(trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'DD')), - 1, 0)) - 1) > trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'MM'))))
	and	 (cd_unidade_basica IS NOT NULL AND cd_unidade_basica::text <> '')
	and	dt_prevista < pkg_date_utils.start_of(dt_referencia_p,'MONTH',0)
	and	obter_se_controla_leitos(cd_setor_desejado,cd_unidade_basica,cd_unidade_compl) = 'S'
	and	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
	and	cd_setor_desejado  = cd_setor
	
union

	select	b.cd_setor_atendimento,
		b.cd_unidade_basica,
		b.cd_unidade_compl,
		null as dt_entrada,
		null as dt_saida,
		0 as qt_dia,
		'A' as ie_status
	from	unidade_atendimento b
	where	b.cd_setor_atendimento = cd_setor
	and	b.ie_situacao = 'A'
	and	obter_se_controla_leitos(b.cd_setor_atendimento,b.cd_unidade_basica,b.cd_unidade_compl) = 'S'
	and	b.cd_unidade_basica not in (select a.cd_unidade_basica
					from	gestao_vaga a
					where (a.dt_prevista between pkg_date_utils.start_of(dt_referencia_p,'MONTH',0) and pkg_date_utils.end_of(dt_referencia_p, 'MONTH', 0))
					and	(a.cd_unidade_basica IS NOT NULL AND a.cd_unidade_basica::text <> '')
					and	obter_se_controla_leitos(a.cd_setor_desejado,a.cd_unidade_basica,a.cd_unidade_compl) = 'S'
					and	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
					and	a.cd_setor_desejado = cd_setor)
	and	b.cd_unidade_basica not in (select cd_unidade_basica
					from	gestao_vaga
					where	((pkg_date_utils.aDD_MONTH(dt_prevista + qt_dia - pkg_date_utils.extract_field('DAY', pkg_date_utils.end_of(dt_referencia_p, 'MONTH', 0)),1,0) between pkg_date_utils.start_of(dt_referencia_p,'MONTH',0) and pkg_date_utils.end_of(pkg_date_utils.aDD_MONTH(dt_referencia_p,12,0), 'MONTH', 0))
					and	((trunc(to_date(dt_prevista,'DD/MM/YYYY'),'MM')<> trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'MM'))
					and	(trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'DD') + (qt_dia - abs(trunc(to_date(dt_prevista,'DD/MM/YYYY'),'DD') - pkg_date_utils.aDD_MONTH(last_DAY(trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'DD')), - 1, 0)) - 1) > trunc(to_date(dt_referencia_p,'DD/MM/YYYY'),'MM'))))
					and	(cd_unidade_basica IS NOT NULL AND cd_unidade_basica::text <> '')
					and	dt_prevista < pkg_date_utils.start_of(dt_referencia_p,'MONTH',0)
					and	obter_se_controla_leitos(cd_setor_desejado,cd_unidade_basica,cd_unidade_compl) = 'S'
					and	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento)
	order by cd_unidade_basica, cd_unidade_compl, dt_entrada;


BEGIN
  delete FROM w_suites;
  open c01;
  loop
    fetch c01
    into cd_setor_desejado_w,
      cd_unidade_basica_w,
      cd_unidade_compl_w,
      dt_entrada_w,
      dt_saida_w,
      qt_dia_w,
      ie_status_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */
    begin
      select coalesce(max(nr_sequencia),0) +1 into STRICT nr_sequencia_w from w_suites;
      select pkg_date_utils.start_of(dt_entrada_w,'MONTH',0)
      into STRICT dt_referencia_w
;

      if (cd_setor_desejado_w <> coalesce(cd_setor_desejado_ant_w,0)) or (cd_unidade_basica_w <> coalesce(cd_unidade_basica_ant_w,'')) or (cd_unidade_compl_w <> coalesce(cd_unidade_compl_ant_w,'')) then
        begin
          dia1_w  := 'A';
          dia2_w  := 'A';
          dia3_w  := 'A';
          dia4_w  := 'A';
          dia5_w  := 'A';
          dia6_w  := 'A';
          dia7_w  := 'A';
          dia8_w  := 'A';
          dia9_w  := 'A';
          dia10_w := 'A';
          dia11_w := 'A';
          dia12_w := 'A';
          dia13_w := 'A';
          dia14_w := 'A';
          dia15_w := 'A';
          dia16_w := 'A';
          dia17_w := 'A';
          dia18_w := 'A';
          dia19_w := 'A';
          dia20_w := 'A';
          dia21_w := 'A';
          dia22_w := 'A';
          dia23_w := 'A';
          dia24_w := 'A';
          dia25_w := 'A';
          dia26_w := 'A';
          dia27_w := 'A';
          dia28_w := 'A';
          dia29_w := 'A';
          dia30_w := 'A';
          dia31_w := 'A';
        end;
      end if;

      dt_refer_w  := dt_entrada_w;
      if (qt_dia_w >= 0 and (dt_refer_w IS NOT NULL AND dt_refer_w::text <> '')) then
        begin
          i              := 0;
          while qt_dia_w >= 0
          loop

            begin
              if (pkg_date_utils.start_of(dt_referencia_w,'MONTH',0) = pkg_date_utils.start_of(dt_refer_w,'MONTH',0)) then
                begin
                  if ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2))    = '01') then
                    dia1_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '02') then
                    dia2_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '03') then
                    dia3_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '04') then
                    dia4_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '05') then
                    dia5_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '06') then
                    dia6_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '07') then
                    dia7_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '08') then
                    dia8_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '09') then
                    dia9_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '10') then
                    dia10_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '11') then
                    dia11_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '12') then
                    dia12_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '13') then
                    dia13_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '14') then
                    dia14_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '15') then
                    dia15_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '16') then
                    dia16_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '17') then
                    dia17_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '18') then
                    dia18_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '19') then
                    dia19_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '20') then
                    dia20_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '21') then
                    dia21_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '22') then
                    dia22_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '23') then
                    dia23_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '24') then
                    dia24_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '25') then
                    dia25_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '26') then
                    dia26_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '27') then
                    dia27_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '28') then
                    dia28_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '29') then
                    dia29_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '30') then
                    dia30_w := ie_status_w;
                  elsif ((substr(pkg_date_utils.start_of(dt_entrada_w,'DD',0) + i,1,2)) = '31') then
                    dia31_w := ie_status_w;
                  end if;
                  select count(*)
                  into STRICT qt_existe_registro_suite_w
                  from w_suites
                  where cd_setor_atendimento     = cd_setor_desejado_w
                  and cd_unidade_basica          = cd_unidade_basica_w
                  and cd_unidade_compl           = cd_unidade_compl_w;
                  if (qt_existe_registro_suite_w = 0) then
                    begin
                      insert
                      into w_suites(
                          nr_sequencia,
                          cd_setor_atendimento,
                          cd_unidade_basica,
                          cd_unidade_compl,
                          dia1,
                          dia2,
                          dia3,
                          dia4,
                          dia5,
                          dia6,
                          dia7,
                          dia8,
                          dia9,
                          dia10,
                          dia11,
                          dia12,
                          dia13,
                          dia14,
                          dia15,
                          dia16,
                          dia17,
                          dia18,
                          dia19,
                          dia20,
                          dia21,
                          dia22,
                          dia23,
                          dia24,
                          dia25,
                          dia26,
                          dia27,
                          dia28,
                          dia29,
                          dia30,
                          dia31,
                          dt_referencia
                        )
                        values (
                          nr_sequencia_w,
                          cd_setor_desejado_w,
                          cd_unidade_basica_w,
                          cd_unidade_compl_w,
                          dia1_w,
                          dia2_w,
                          dia3_w,
                          dia4_w,
                          dia5_w,
                          dia6_w,
                          dia7_w,
                          dia8_w,
                          dia9_w,
                          dia10_w,
                          dia11_w,
                          dia12_w,
                          dia13_w,
                          dia14_w,
                          dia15_w,
                          dia16_w,
                          dia17_w,
                          dia18_w,
                          dia19_w,
                          dia20_w,
                          dia21_w,
                          dia22_w,
                          dia23_w,
                          dia24_w,
                          dia25_w,
                          dia26_w,
                          dia27_w,
                          dia28_w,
                          dia29_w,
                          dia30_w,
                          dia31_w,
                          dt_referencia_w
                        );
                    end;
                  else
                    begin
                      select nr_sequencia
                      into STRICT nr_seq_suite_w
                      from w_suites
                      where cd_setor_atendimento = cd_setor_desejado_w
                      and cd_unidade_basica      = cd_unidade_basica_w
                      and cd_unidade_compl       = cd_unidade_compl_w;
                      update w_suites
                      set dia1           = dia1_w,
                        dia2             = dia2_w,
                        dia3             = dia3_w,
                        dia4             = dia4_w,
                        dia5             = dia5_w,
                        dia6             = dia6_w,
                        dia7             = dia7_w,
                        dia8             = dia8_w,
                        dia9             = dia9_w,
                        dia10            = dia10_w,
                        dia11            = dia11_w,
                        dia12            = dia12_w,
                        dia13            = dia13_w,
                        dia14            = dia14_w,
                        dia15            = dia15_w,
                        dia16            = dia16_w,
                        dia17            = dia17_w,
                        dia18            = dia18_w,
                        dia19            = dia19_w,
                        dia20            = dia20_w,
                        dia21            = dia21_w,
                        dia22            = dia22_w,
                        dia23            = dia23_w,
                        dia24            = dia24_w,
                        dia25            = dia25_w,
                        dia26            = dia26_w,
                        dia27            = dia27_w,
                        dia28            = dia28_w,
                        dia29            = dia29_w,
                        dia30            = dia30_w,
                        dia31            = dia31_w
                      where nr_sequencia = nr_seq_suite_w;
                    end;
                  end if;
                end;
              end if;
              i          := i          + 1;
              qt_dia_w   := qt_dia_w   - 1;
              dt_refer_w := dt_refer_w + 1;
            end;
          end loop;
        end;
      else
        begin
          insert
          into w_suites(
              nr_sequencia,
              cd_setor_atendimento,
              cd_unidade_basica,
              cd_unidade_compl,
              dia1,
              dia2,
              dia3,
              dia4,
              dia5,
              dia6,
              dia7,
              dia8,
              dia9,
              dia10,
              dia11,
              dia12,
              dia13,
              dia14,
              dia15,
              dia16,
              dia17,
              dia18,
              dia19,
              dia20,
              dia21,
              dia22,
              dia23,
              dia24,
              dia25,
              dia26,
              dia27,
              dia28,
              dia29,
              dia30,
              dia31,
              dt_referencia
            )
            values (
              nr_sequencia_w,
              cd_setor_desejado_w,
              cd_unidade_basica_w,
              cd_unidade_compl_w,
              dia1_w,
              dia2_w,
              dia3_w,
              dia4_w,
              dia5_w,
              dia6_w,
              dia7_w,
              dia8_w,
              dia9_w,
              dia10_w,
              dia11_w,
              dia12_w,
              dia13_w,
              dia14_w,
              dia15_w,
              dia16_w,
              dia17_w,
              dia18_w,
              dia19_w,
              dia20_w,
              dia21_w,
              dia22_w,
              dia23_w,
              dia24_w,
              dia25_w,
              dia26_w,
              dia27_w,
              dia28_w,
              dia29_w,
              dia30_w,
              dia31_w,
              dt_referencia_w
            );

            select count(*)
            into STRICT counter
            from w_suites;
        end;
      end if;
      dt_entrada_ant_w        := dt_entrada_w;
      dt_saida_ant_w          := dt_saida_w;
      cd_setor_desejado_ant_w := cd_setor_desejado_w;
      cd_unidade_basica_ant_w := cd_unidade_basica_w;
      cd_unidade_compl_ant_w  := cd_unidade_compl_w;
      ds_cor_ant_w            := ie_status_w;
    end;
  end loop;
  close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_wdeptbeds_html ( dt_referencia_p timestamp, cd_setor unidade_atendimento.cd_setor_atendimento%type) FROM PUBLIC;
