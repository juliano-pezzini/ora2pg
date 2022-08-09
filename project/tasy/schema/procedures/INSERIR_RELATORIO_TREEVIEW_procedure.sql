-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_relatorio_treeview ( nm_usuario_p text) AS $body$
DECLARE




cd_relatorio_w				bigint;
cd_classif_relat_w			varchar(255);
ds_titulo_w					varchar(255);
cd_relatorio_d_w			bigint;
cd_classif_relat_d_w		varchar(255);
ds_titulo_d_w				varchar(255);
cd_relatorio_3_w			bigint;
ds_titulo_3_w				varchar(255);
cd_relatorio_4_w			bigint;
ds_titulo_4_w				varchar(255);
list_function_reports_w		bigint;



C01 CURSOR FOR

   SELECT  substr(Obter_classif_Relatorio(b.nr_sequencia,'C'),1,30)
                    CD_RELATORIO,
                    substr(Obter_classif_Relatorio(b.nr_sequencia,'CL'),1,30)
                    CD_CLASS,
                    SUBSTR(OBTER_DESCRICAO_PADRAO('RELATORIO','DS_TITULO',b.nr_sequencia),1,80)
                    DS_TITULO
    FROM    RELATORIO_FUNCAO a,
            relatorio b
where   a.cd_funcao          = 422
    and a.nr_seq_relatorio = b.nr_sequencia
    and (exists (SELECT 1 from relatorio_perfil where cd_perfil = wheb_usuario_pck.get_cd_perfil and b.nr_sequencia = nr_seq_relatorio)
        or exists (select 1 from usuario_relatorio where NM_USUARIO_REF = nm_usuario_p and b.nr_sequencia = nr_seq_relatorio))
    and not exists (select 1 from tree_report_dar where nm_usuario = nm_usuario_p and b.cd_relatorio = cd_relatorio);
					
C02 CURSOR FOR

SELECT
    x.cd_relatorio,
    x.cd_classif_relat,
    x.ds_titulo
    FROM    TREE_REPORT_DAR x
    where  x.nm_usuario = nm_usuario_p
    AND not EXISTS (SELECT 1
                    from    RELATORIO_FUNCAO a,
                            relatorio b
                    WHERE CD_FUNCAO = 422
                    and a.nr_seq_relatorio = b.nr_sequencia
					and b.cd_relatorio = x.cd_relatorio
                    and (exists (select 1 from relatorio_perfil where cd_perfil = wheb_usuario_pck.get_cd_perfil and b.nr_sequencia = nr_seq_relatorio)
                    or exists (select 1 from usuario_relatorio where NM_USUARIO_REF = nm_usuario_p and b.nr_sequencia = nr_seq_relatorio)));

C03 CURSOR FOR

SELECT
    x.cd_relatorio,
    x.ds_titulo
    FROM    TREE_REPORT_DAR x
    where  x.nm_usuario = nm_usuario_p
    AND EXISTS (SELECT 1
                    from    RELATORIO_FUNCAO a,
                            relatorio b
                    WHERE CD_FUNCAO = 422
                    and a.nr_seq_relatorio = b.nr_sequencia
					and b.cd_relatorio = x.cd_relatorio
                    and (exists (select 1 from relatorio_perfil where cd_perfil = wheb_usuario_pck.get_cd_perfil and b.nr_sequencia = nr_seq_relatorio)
                    or exists (select 1 from usuario_relatorio where NM_USUARIO_REF = nm_usuario_p and b.nr_sequencia = nr_seq_relatorio)));

C04 CURSOR FOR

SELECT
    substr(Obter_classif_Relatorio(nr_seq_relatorio,'C'),1,30)
    CD_RELATORIO,
    SUBSTR(OBTER_DESCRICAO_PADRAO('RELATORIO','DS_TITULO',NR_SEQ_RELATORIO),1,80)
    DS_TITULO
    FROM    RELATORIO_FUNCAO a,
            relatorio b
where   a.cd_funcao          = 422
    and a.nr_seq_relatorio = b.nr_sequencia
    and (exists (SELECT 1 from relatorio_perfil where cd_perfil = wheb_usuario_pck.get_cd_perfil and b.nr_sequencia = nr_seq_relatorio)
        or exists (select 1 from usuario_relatorio where NM_USUARIO_REF = nm_usuario_p and b.nr_sequencia = nr_seq_relatorio))
    and exists (select 1 from tree_report_dar where nm_usuario = nm_usuario_p and b.cd_relatorio = cd_relatorio);
		
	

BEGIN
open C01;
	loop
		fetch C01 into			
          	cd_relatorio_w,
			cd_classif_relat_w,
			ds_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
				begin
					if (cd_relatorio_w IS NOT NULL AND cd_relatorio_w::text <> '') then
						insert into TREE_REPORT_DAR(	nr_sequencia,
								nm_usuario,
								nm_usuario_nrec,
								dt_atualizacao,
								dt_atualizacao_nrec,
								nr_seq_pai,
								nr_seq_ordem,
								ie_tipo,
								cd_relatorio,
								cd_classif_relat,
								ds_titulo
								)
						values (   nextval('tree_report_dar_seq'),
								nm_usuario_p,
								null,
								clock_timestamp(),
								clock_timestamp(),
								null,
								1,
								'R',
								cd_relatorio_w,
								cd_classif_relat_w,
								ds_titulo_w
								);
						commit;
					end if;
				end;
			end;
	end loop;
close C01;

open C02;
	loop
		fetch C02 into			
          	cd_relatorio_d_w,
			cd_classif_relat_d_w,
			ds_titulo_d_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
				begin
					if (cd_relatorio_d_w IS NOT NULL AND cd_relatorio_d_w::text <> '') then
						DELETE from TREE_REPORT_DAR
						where CD_RELATORIO = cd_relatorio_d_w
						and nm_usuario = nm_usuario_p;
						commit;
					end if;
				end;
			end;
	end loop;
close C02;

open C03;
	loop
		fetch C03 into			
          	cd_relatorio_3_w,
			ds_titulo_3_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
				begin
					open C04;
						loop
							fetch C04 into			
								cd_relatorio_4_w,
								ds_titulo_4_w;
							EXIT WHEN NOT FOUND; /* apply on C04 */
								begin
									begin
										if (cd_relatorio_3_w = cd_relatorio_4_w AND ds_titulo_3_w != ds_titulo_4_w) then
											UPDATE TREE_REPORT_DAR SET	ds_titulo = ds_titulo_4_w
											where CD_RELATORIO = cd_relatorio_4_w
											and nm_usuario = nm_usuario_p;
											commit;
										end if;
									end;
								end;
						end loop;
					close C04;
				end;
			end;
	end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_relatorio_treeview ( nm_usuario_p text) FROM PUBLIC;
