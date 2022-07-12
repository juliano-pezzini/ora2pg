-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_contab_mexico_pck.get_arquivo_d_xml ( nr_seq_regra_p w_ctb_contab_mexico.nr_seq_regra%type) RETURNS xml AS $body$
DECLARE


    arquivo_xml_w               xml;


BEGIN

    begin

    select  xmlroot(
            updatexml(
                xmlagg(xmlelement("PLZ:Polizas",
                    xmlattributes(
                    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo/PolizasPeriodo_1_3.xsd' "xsi:schemaLocation",
                    'http://www.w3.org/2001/XMLSchema-instance' "xmlns:xsi",
                    'http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo' "xmlns:PLZ",
                    a.cd_versao "Version",
                    a.cd_cpf_cgc "RFC",
                    a.ds_mes "Mes",
                    a.ds_ano "Anio",
                    a.ie_tipo_solicitacao "TipoSolicitud",
                    a.nr_ordem "NumOrden",
                    a.nr_tramite "NumTramite",
                    null "Sello",
                    a.nr_certificado_sat "Certificado",
                    null "noCertificado"),
                    (select xmlagg(
                            xmlelement("PLZ:Poliza",
                                xmlattributes(
                                    coalesce(b.nr_lote_contabil,'$null_req_field$') "NumUnIdenPol",
                                    coalesce(b.dt_referencia,'$null_req_field$') "Fecha",
                                    coalesce(b.ds_tipo_lote_contabil,'$null_req_field$') "Concepto"
                                )
                                ,
                                (select xmlagg(
                                        xmlelement("PLZ:Transaccion",
                                            xmlattributes(
                                                coalesce(c.cd_classificacao,'$null_req_field$') "NumCta",
                                                c.ds_conta_contabil "DesCta",
                                                c.ds_historico "Concepto",
                                                coalesce(trim(both to_char(c.vl_debito,'999999999999999.99')),'$null_req_field$') "Debe",
                                                coalesce(trim(both to_char(c.vl_credito,'999999999999999.99')),'$null_req_field$') "Haber"
                                            ),
                                            (select xmlagg(
                                                    XMLELEMENT(name "PLZ:CompNal",
                                                        xmlattributes(
                                                            coalesce(d.ds_uuid_cfdi,'$null_req_field$') "UUID_CFDI",
                                                            coalesce(d.cd_cpf_cgc,'$null_req_field$') "RFC",
                                                            coalesce(d.vl_transacao,'$null_req_field$') "MontoTotal",
                                                            d.cd_moeda_estrangeira "Moneda",
                                                            d.vl_conv_estrangeiro "TipCamb"
                                                        )
                                                    )
                                                )
                                            from    w_ctb_contab_mexico d
                                            where   d.nr_seq_regra = c.nr_seq_regra
                                            and     d.nr_seq_superior = c.nr_sequencia_ctb_movto
                                            and d.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.comp_nal
                                                                                    and     (d.ds_uuid_cfdi IS NOT NULL AND d.ds_uuid_cfdi::text <> '')
                                            ) compnal,
                                            (select xmlagg(
                                                    XMLELEMENT(name "PLZ:CompExt",
                                                        xmlattributes(
                                                            coalesce(e.nr_nota_fiscal,'$null_req_field$') "NumFactExt",
                                                            e.cd_cpf_cgc "TaxID",
                                                            coalesce(e.vl_transacao,'$null_req_field$') "MontoTotal",
                                                            e.cd_moeda_estrangeira "Moneda",
                                                            e.vl_conv_estrangeiro "TipCamb"
                                                        )
                                                    )
                                                )
                                            from    w_ctb_contab_mexico e
                                            where   e.nr_seq_regra = c.nr_seq_regra
                                            and     e.nr_seq_superior = c.nr_sequencia_ctb_movto
                                            and e.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.comp_ext
                                            ) compext,
                                            (select xmlagg(
                                                    XMLELEMENT(name "PLZ:Cheque",
                                                        xmlattributes(
                                                            coalesce(f.nr_cheque,'$null_req_field$') "Num",
                                                            coalesce(f.cd_banco,'$null_req_field$') "BanEmisNal",
                                                            null "BanEmisExt",
                                                            coalesce(f.cd_conta_digito,'$null_req_field$') "CtaOri",
                                                            coalesce(f.dt_referencia,'$null_req_field$') "Fecha",
                                                            coalesce(f.ds_nome_pf_pj,'$null_req_field$') "Benef",
                                                            coalesce(f.cd_cpf_cgc,'$null_req_field$') "RFC",
                                                            coalesce(f.vl_transacao,'$null_req_field$') "Monto",
                                                            f.cd_moeda_estrangeira "Moneda",
                                                            f.vl_conv_estrangeiro "TipCamb"
                                                        )
                                                    )
                                                )
                                            from    w_ctb_contab_mexico f
                                            where   f.nr_seq_regra = c.nr_seq_regra
                                            and     f.nr_seq_superior = c.nr_sequencia_ctb_movto
                                            and f.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.cheque
                                            ) cheque,
                                            (select xmlagg(
                                                    XMLELEMENT(name "PLZ:Transferencia",
                                                        xmlattributes(
                                                            g.cd_conta_digito "CtaOri",
                                                            coalesce(g.cd_banco,'$null_req_field$') "BancoOriNal",
                                                            null "BancoOriExt",
                                                            coalesce(g.cd_conta_dest,'$null_req_field$') "CtaDest",
                                                            coalesce(g.cd_banco_dest,'$null_req_field$') "BancoDestNal",
                                                            null "BancoDestExt",
                                                            coalesce(g.dt_referencia,'$null_req_field$') "Fecha",
                                                            coalesce(g.ds_nome_pf_pj,'$null_req_field$') "Benef",
                                                            coalesce(g.cd_cpf_cgc,'$null_req_field$') "RFC",
                                                            coalesce(g.vl_transacao,'$null_req_field$') "Monto",
                                                            g.cd_moeda_estrangeira "Moneda",
                                                            null "TipCamb"
                                                        )
                                                    )
                                                )
                                            from    w_ctb_contab_mexico g
                                            where   g.nr_seq_regra = c.nr_seq_regra
                                            and     g.nr_seq_superior = c.nr_sequencia_ctb_movto
                                            and g.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.transferencia
                                            ) transferencia,
                                            (select xmlagg(
                                                    XMLELEMENT(name "PLZ:OtrMetodoPago",
                                                        xmlattributes(
                                                            coalesce(h.cd_integracao_externa,'$null_req_field$') "MetPagoPol",
                                                            coalesce(h.dt_referencia,'$null_req_field$') "Fecha",
                                                            coalesce(h.ds_nome_pf_pj,'$null_req_field$') "Benef",
                                                            coalesce(h.cd_cpf_cgc,'$null_req_field$') "RFC",
                                                            coalesce(h.vl_transacao,'$null_req_field$') "Monto",
                                                            h.cd_moeda_estrangeira "Moneda",
                                                            null "TipCamb"
                                                        )
                                                    )
                                                )
                                            from    w_ctb_contab_mexico h
                                            where   h.nr_seq_regra = c.nr_seq_regra
                                            and     h.nr_seq_superior = c.nr_sequencia_ctb_movto
                                            and h.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.otr_metodo_pago
                                            ) otrmetodopago
                                        ) order by a.nr_sequencia
                                    )
                                from    w_ctb_contab_mexico c
                                where   c.nr_seq_regra = b.nr_seq_regra
                                and     c.nr_seq_superior = b.nr_sequencia
                                and c.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.transaccion
                                ) transaccion
                            )
                        )
                    from    w_ctb_contab_mexico b
                    where   b.nr_seq_regra = a.nr_seq_regra
                    and     b.nr_seq_superior = a.nr_sequencia
                    and b.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.poliza
                    ) poliza
                )),
            '//*[@*="$null_req_field$"]/@*', null),
        version '1.0" encoding="UTF-8') polizas
    into STRICT    arquivo_xml_w
    from    w_ctb_contab_mexico a
    where   a.nr_seq_regra = nr_seq_regra_p
    and     a.ie_tipo_atributo = current_setting('ctb_contab_mexico_pck.tipo_registro')::r_tipo_registro.polizas_del_periodo;

    exception
        when no_data_found then
            arquivo_xml_w := xmltype('<row></row>');
    end;

    return arquivo_xml_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_contab_mexico_pck.get_arquivo_d_xml ( nr_seq_regra_p w_ctb_contab_mexico.nr_seq_regra%type) FROM PUBLIC;