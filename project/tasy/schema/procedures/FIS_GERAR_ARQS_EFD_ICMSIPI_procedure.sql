-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_arqs_efd_icmsipi (nr_seq_controle_p bigint) AS $body$
DECLARE


-- VARIABLES
nr_linha_w		bigint := 0;
qt_total_w		bigint;
qt_contador_w	bigint := 0;
ds_proc_longo_w	varchar(40);
ds_proc_w		varchar(255);
nm_usuario_w		usuario.nm_usuario%type;

-- FIS_EFD_ICMSIPI_CONTROLE
nr_seq_lote_w			fis_efd_icmsipi_controle.nr_seq_lote%type;

-- FIS_EFD_ICMSIPI_REG_LOTE
ds_registro_w			fis_efd_icmsipi_reg_lote.ds_registro%type;

-- CURSOR DOS REGISTROS
c01 CURSOR FOR
	SELECT	ds_registro
	from	fis_efd_icmsipi_reg_lote
	where	nr_seq_lote	= nr_seq_lote_w
	and		ie_gerar	= 'S'
	and     coalesce(ie_nivel,0) <= 2
	order by nr_sequencia;


BEGIN
nr_linha_w := 0;

select	max(nr_seq_lote)
into STRICT	nr_seq_lote_w
from	fis_efd_icmsipi_controle
where	nr_sequencia	= nr_seq_controle_p;

select	count(*)
into STRICT	qt_total_w
from	fis_efd_icmsipi_reg_lote
where	nr_seq_lote	= nr_seq_lote_w
and		ie_gerar		= 'S';

delete FROM fis_efd_icmsipi_arquivo
where nr_seq_controle = nr_seq_controle_p;

open c01;
loop
fetch c01 into
	ds_registro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
begin
	qt_contador_w 	:= qt_contador_w + 1;

	ds_proc_longo_w	:= substr(wheb_mensagem_pck.get_texto(300326),1,40);
	CALL gravar_processo_longo(ds_proc_longo_w || ': ' || ds_registro_w || ' ('|| qt_contador_w ||'/' ||qt_total_w ||')','FIS_GERAR_ARQ_EFD_ICMSIPI', qt_contador_w);

	if (substr(ds_registro_w,2,3) = '001') then
		nr_linha_w := fis_gerar_arq_abertura_icmsipi(nr_seq_controle_p, ds_registro_w, nr_linha_w);
	elsif (substr(ds_registro_w,2,3) = '990') then
		nr_linha_w := fis_gerar_arq_encerram_icmsipi(nr_seq_controle_p, ds_registro_w, nr_linha_w);
	else

		ds_proc_w := 'begin fis_gerar_arq_' || ds_registro_w || '_icmsipi(:1, :2); end;';
		EXECUTE ds_proc_w using nr_seq_controle_p, in out nr_linha_w;
	end if;
end;
end loop;
close c01;

nr_linha_w := fis_gerar_arq_abertura_icmsipi(nr_seq_controle_p, '1001', nr_linha_w);
nr_linha_w := fis_gerar_arq_1010_icmsipi(nr_seq_controle_p, nr_linha_w);
nr_linha_w := fis_gerar_arq_encerram_icmsipi(nr_seq_controle_p, '1990', nr_linha_w);

nr_linha_w := fis_gerar_arq_abertura_icmsipi(nr_seq_controle_p, '9001', nr_linha_w);
nr_linha_w := fis_gerar_arq_9900_icmsipi(nr_seq_controle_p, nr_linha_w);
nr_linha_w := fis_gerar_arq_encerram_icmsipi(nr_seq_controle_p, '9990', nr_linha_w);
nr_linha_w := fis_gerar_arq_9999_icmsipi(nr_seq_controle_p, nr_linha_w);

nm_usuario_w := Obter_Usuario_Ativo;

insert into fis_efd_icmsipi_arquivo(nr_sequencia,
                                    dt_atualizacao_nrec,
                                    nm_usuario_nrec,
                                    dt_atualizacao,
                                    nm_usuario,
                                    nr_seq_controle,
                                    nr_linha,
                                    ds_arquivo,
                                    ds_arquivo_compl,
                                    cd_registro)
                            values (nextval('fis_efd_icmsipi_arquivo_seq'),
                                   clock_timestamp(),
                                   nm_usuario_w,
                                   clock_timestamp(),
                                   nm_usuario_w,
                                   nr_seq_controle_p,
                                   nr_linha_w + 1,
                                   CHR('10'),
                                   null,
                                   '9999');

commit;

update   fis_efd_icmsipi_controle a
set      a.dt_geracao	=  clock_timestamp()
where    a.nr_sequencia	= nr_seq_controle_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_arqs_efd_icmsipi (nr_seq_controle_p bigint) FROM PUBLIC;
